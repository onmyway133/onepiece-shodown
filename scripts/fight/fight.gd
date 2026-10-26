extends Node2D
## A match: stage, two fighters, camera, hit resolution, rounds and HUD.

const Stage := preload("res://scripts/fight/stage.gd")
const Fx := preload("res://scripts/fight/fx.gd")
const Projectile := preload("res://scripts/fight/projectile.gd")
const Hud := preload("res://scripts/ui/hud.gd")
const AI := preload("res://scripts/fight/ai.gd")
const Menu := preload("res://scripts/ui/menu.gd")

const HALF := 1100.0
const WALL := 1040.0
const MAX_SEP := 880.0
const PUSH_W := 40.0


class Human:
	var p := 1
	var merge := false

	func _init(player: int, both := false) -> void:
		p = player
		merge = both

	func get_input(_f) -> Dictionary:
		return Controls.read(p, merge)


class Showcase:
	## Scripted inputs that perform every special with real motion inputs (for tests).
	var seq: Array = []
	var i := 0
	var left := 0

	func _init() -> void:
		var motions := [
			[[0, -1], [1, -1], [1, 0], "light"], [[0, -1], [1, -1], [1, 0], "heavy"],
			[[0, -1], [-1, -1], [-1, 0], "light"], [[1, 0], [0, -1], [1, -1], "light"], ["super"],
		]
		for m in motions:
			for step in m:
				var d := Controls.empty()
				if step is String:
					d[step] = true
					d[step + "_held"] = true
					seq.append([d, 1])
				else:
					d.x = step[0]
					d.y = step[1]
					seq.append([d, 3])
			seq.append([Controls.empty(), 110])

	func get_input(f) -> Dictionary:
		if f.state == "idle" and seq.size() > 0 and i < seq.size():
			pass
		if i >= seq.size():
			return Controls.empty()
		var cur: Array = seq[i]
		left += 1
		if left >= int(cur[1]):
			left = 0
			i += 1
		var d: Dictionary = cur[0].duplicate()
		d.x = int(d.x) * f.facing
		return d


class Dummy:
	var mode := "stand"

	func get_input(f) -> Dictionary:
		var inp := Controls.empty()
		if mode == "block" and f.opp:
			inp.x = -1 if f.opp.position.x > f.position.x else 1
		elif mode == "crouch":
			inp.y = -1
		return inp


var data := {}
var stage: Node2D
var world := Node2D.new()
var fx: Node2D
var cam := Camera2D.new()
var hud: Control
var hud_layer := CanvasLayer.new()
var flash_layer := CanvasLayer.new()
var flash_rect := ColorRect.new()
var flash_t := 0
var flash_len := 1
var flash_col := Color.WHITE
var f1: Fighter
var f2: Fighter
var fighters: Array = []
var projectiles: Array = []

var state := "intro"
var st_t := 0
var round_num := 1
var time_left := 60
var _sec := 0
var super_freeze := 0
var shake_amt := 0.0
var zoom_punch := 0.0
var ko_real := 0.0
var winner: Fighter = null
var menu: Control = null
var debug := {}
var frame := 0
var training_refill := [0, 0]


func setup(d: Dictionary) -> void:
	data = d
	debug = d.get("debug", {})


func _ready() -> void:
	stage = Stage.new()
	add_child(stage)
	stage.setup(Game.stage)
	CharData.rim = Game.stage_rim(Game.stage)
	add_child(world)
	fx = Fx.new()
	add_child(fx)
	add_child(cam)
	cam.make_current()
	cam.position = Vector2(0, -300)
	add_child(flash_layer)
	flash_layer.layer = 4
	flash_rect.size = Vector2(1280, 720)
	flash_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	flash_rect.color = Color(1, 1, 1, 0)
	flash_layer.add_child(flash_rect)
	add_child(hud_layer)
	hud_layer.layer = 5
	hud = Hud.new()
	hud_layer.add_child(hud)

	f1 = Fighter.new()
	f2 = Fighter.new()
	var c1: Object
	var c2: Object
	match Game.mode:
		"versus":
			c1 = Human.new(1)
			c2 = Human.new(2)
		"training":
			c1 = Human.new(1, true)
			c2 = Dummy.new()
		"demo":
			c1 = AI.new(int(debug.get("lv1", "2")))
			if debug.has("showcase"):
				c1 = Showcase.new()
			c2 = AI.new(int(debug.get("lv2", "2")))
			if debug.has("showcase"):
				c2 = Dummy.new()
		_:
			c1 = Human.new(1, true)
			c2 = AI.new(Game.difficulty)
	f1.setup(Game.char_data(Game.p1_char), 1, c1)
	f2.setup(Game.char_data(Game.p2_char), 2, c2)
	for f in [f1, f2]:
		f.fight = self
		world.add_child(f)
	f1.opp = f2
	f2.opp = f1
	fighters = [f1, f2]
	fx.fighters = fighters
	hud.setup(self, f1, f2)
	start_round()
	Sfx.music("battle")


func start_round() -> void:
	for p in projectiles:
		p.queue_free()
	projectiles.clear()
	fx.clear()
	f1.reset_round(-230.0)
	f2.reset_round(230.0)
	f1.facing = 1
	f2.facing = -1
	time_left = Game.round_time
	_sec = 0
	state = "intro"
	st_t = 0
	winner = null
	Engine.time_scale = 1.0
	cam.position = Vector2(0, -300)


# ---------------------------------------------------------------- main loop

func _physics_process(_delta: float) -> void:
	frame += 1
	_debug_hooks()
	_flash_step()
	if super_freeze > 0:
		super_freeze -= 1
		_camera()
		return
	st_t += 1
	_flow()
	for f in fighters:
		f.tick()
	_push_apart()
	for p in projectiles:
		p.tick(fx)
	_resolve_hits()
	_projectile_hits()
	for p in projectiles.duplicate():
		if p.dead:
			projectiles.erase(p)
			p.queue_free()
	_check_ko()
	_camera()


func _flow() -> void:
	match state:
		"intro":
			if st_t == 20:
				hud.banner("ROUND %d" % round_num if not _final_round() else "FINAL ROUND", 70, 100)
				Sfx.play("gong", -2.0, 1.0, 0.0)
			if st_t == 30:
				for f in fighters:
					f.play("intro", [[30, f.cd.pose("intro")]])
			if st_t == 95:
				hud.banner("FIGHT!", 45, 140, Color(1, 0.5, 0.3))
				Sfx.play("fight", 0.0, 1.0, 0.0)
				for f in fighters:
					f.locked = false
					f.set_state("idle")
			if st_t >= 95:
				state = "fight"
				st_t = 0
		"fight":
			if debug.has("showcase"):
				f1.hp = f1.cd.max_hp
				f2.hp = f2.cd.max_hp
				if f1.state == "idle" and f1.rage_mode == 0:
					f1.add_rage(100.0)
			if Game.mode == "training":
				_training()
				return
			_sec += 1
			if _sec >= 60:
				_sec = 0
				time_left -= 1
				if time_left <= 0:
					time_left = 0
					_time_over()
		"round_end":
			if st_t == 150:
				if winner and winner.wins >= Game.rounds_to_win:
					_match_end()
				else:
					round_num += 1
					start_round()
		"match_end":
			if Game.mode == "demo" and st_t == 300:
				f1.wins = 0
				f2.wins = 0
				round_num = 1
				start_round()


func _final_round() -> bool:
	return f1.wins == Game.rounds_to_win - 1 and f2.wins == Game.rounds_to_win - 1


func _training() -> void:
	for i in 2:
		var f: Fighter = fighters[i]
		if f.hp < f.cd.max_hp and f.state in Fighter.NEUTRAL:
			training_refill[i] += 1
			if training_refill[i] > 50:
				f.hp = f.cd.max_hp
		else:
			training_refill[i] = 0
		if f.hp <= 0.0:
			f.hp = 1.0
			f.ko = false
		if f.player == 1 and f.rage_mode == 0 and f.state in Fighter.NEUTRAL:
			f.rage = minf(100.0, f.rage + 0.5)
			if f.rage >= 100.0:
				f.add_rage(1.0)


func _process(delta: float) -> void:
	if state == "ko":
		ko_real += delta
		if ko_real > 1.2:
			Engine.time_scale = 1.0
		var loser: Fighter = f1 if f1.ko else f2
		if ko_real > 2.4 and (loser.state == "ko_down" or ko_real > 5.0):
			_round_won()
	if Game.mode == "demo" and debug.is_empty():
		if Input.is_action_just_pressed("pause") or Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("p1_light"):
			get_parent().goto("res://scripts/ui/title.gd")
		return
	if Input.is_action_just_pressed("pause") and menu == null and state in ["fight", "intro"]:
		_pause()


# ---------------------------------------------------------------- collisions

func _push_apart() -> void:
	for f in fighters:
		f.position.x = clampf(f.position.x, -WALL, WALL)
	var dx := f2.position.x - f1.position.x
	if absf(dx) > MAX_SEP:
		var mid := (f1.position.x + f2.position.x) * 0.5
		var s := signf(dx)
		f1.position.x = mid - s * MAX_SEP * 0.5
		f2.position.x = mid + s * MAX_SEP * 0.5
	if absf(f1.position.y - f2.position.y) > 150.0:
		return
	if f1.state in ["down", "ko_down"] or f2.state in ["down", "ko_down"]:
		return
	for f in fighters:
		if f.state == "attack" and f.move.get("pass", false):
			return
	dx = f2.position.x - f1.position.x
	var overlap := PUSH_W * 2.0 - absf(dx)
	if overlap > 0.0:
		var s := signf(dx)
		if s == 0.0:
			s = float(f1.facing)
		f1.position.x -= s * overlap * 0.5
		f2.position.x += s * overlap * 0.5
		for f in fighters:
			if absf(f.position.x) > WALL:
				var over := absf(f.position.x) - WALL
				f.position.x = signf(f.position.x) * WALL
				var o: Fighter = f.opp
				o.position.x -= signf(f.position.x) * over


static func seg_dist(p1: Vector2, q1: Vector2, p2: Vector2, q2: Vector2) -> Array:
	# closest points between two segments -> [distance, point]
	var d1 := q1 - p1
	var d2 := q2 - p2
	var r := p1 - p2
	var a := d1.dot(d1)
	var e := d2.dot(d2)
	var f := d2.dot(r)
	var s := 0.0
	var t := 0.0
	if a <= 0.0001 and e <= 0.0001:
		return [p1.distance_to(p2), (p1 + p2) * 0.5]
	if a <= 0.0001:
		t = clampf(f / e, 0.0, 1.0)
	else:
		var c := d1.dot(r)
		if e <= 0.0001:
			s = clampf(-c / a, 0.0, 1.0)
		else:
			var b := d1.dot(d2)
			var denom := a * e - b * b
			if denom != 0.0:
				s = clampf((b * f - c * e) / denom, 0.0, 1.0)
			t = (b * s + f) / e
			if t < 0.0:
				t = 0.0
				s = clampf(-c / a, 0.0, 1.0)
			elif t > 1.0:
				t = 1.0
				s = clampf((b - c) / a, 0.0, 1.0)
	var c1 := p1 + d1 * s
	var c2 := p2 + d2 * t
	return [c1.distance_to(c2), (c1 + c2) * 0.5]


func _resolve_hits() -> void:
	var pending := []
	for f in fighters:
		var o: Fighter = f.opp
		if not o.hittable():
			continue
		for ah in f.active_hits():
			var hurt := o.hurt_world()
			var best := []
			for c in hurt:
				var res := seg_dist(ah.a, ah.b, c[0], c[1])
				if res[0] < ah.r + c[2]:
					best = res
					break
			if best.size() > 0:
				pending.append([f, o, ah.h, best[1]])
				break
	for p in pending:
		_apply_hit(p[0], p[1], p[2], p[3], p[0].position.x)


func _apply_hit(atk: Fighter, def: Fighter, h: Dictionary, point: Vector2, from_x: float, proj := false) -> void:
	if not proj:
		atk.hit_done[h.id] = true
		atk.connected = true
	var landed := def.take_hit(from_x, h, atk.damage_mult())
	var facing := 1 if def.position.x > from_x else -1
	if not proj:
		atk.hitstop = def.hitstop
	if landed:
		var spark: String = h.spark
		fx.spark(point, spark, facing)
		Sfx.play(String(h.sfx))
		atk.add_rage(float(h.dmg) * 0.04)
		var hs: int = h.hs
		if hs >= 10:
			shake(hs * 0.7)
			zoom_punch = 0.06
			impact_frame(Color(1, 0.97, 0.9), 3, 0.45)
			fx.impact_lines(point, 16, 300.0)
		elif hs >= 7:
			shake(3.0)
		if def.combo >= 2:
			hud.combo(atk.player, def.combo)
	else:
		fx.spark(point, "block", facing)
		Sfx.play("block")
	# corner pushback goes to the attacker
	if absf(def.position.x) >= WALL - 30.0 and not proj and atk.on_ground():
		atk.vel.x = -facing * float(h.kb) * 0.7


func _projectile_hits() -> void:
	# projectile clashes
	for i in projectiles.size():
		for j in range(i + 1, projectiles.size()):
			var a = projectiles[i]
			var b = projectiles[j]
			if a.dead or b.dead or a.owner_f == b.owner_f:
				continue
			if a.position.distance_to(b.position) < (a.r + b.r) * 0.8 * Fighter.SCALE:
				a.hp -= 1
				b.hp -= 1
				fx.spark((a.position + b.position) * 0.5, "heavy", 1)
				Sfx.play("clash")
				if a.hp <= 0:
					a.dead = true
				if b.hp <= 0:
					b.dead = true
	for p in projectiles:
		if not p.can_hit():
			continue
		var o: Fighter = p.owner_f.opp
		if not o.hittable():
			continue
		for c in o.hurt_world():
			var res := seg_dist(p.position, p.position, c[0], c[1])
			if res[0] < p.r * Fighter.SCALE + c[2]:
				p.on_hit()
				_apply_hit(p.owner_f, o, p.hit, res[1], p.position.x - p.vel.x * 3.0, true)
				break


func spawn_projectile(f: Fighter, d: Dictionary) -> void:
	var p := Projectile.new()
	p.setup(f, d)
	world.add_child(p)
	projectiles.append(p)


# ---------------------------------------------------------------- events

## Full screen flash for big impacts, supers and KOs.
func impact_frame(c: Color, frames := 3, strength := 0.5) -> void:
	flash_col = Color(c.r, c.g, c.b, strength)
	flash_t = frames
	flash_len = frames


func _flash_step() -> void:
	if flash_t > 0:
		var u := float(flash_t) / flash_len
		flash_rect.color = Color(flash_col.r, flash_col.g, flash_col.b, flash_col.a * u)
		flash_t -= 1
	else:
		flash_rect.color.a = 0.0


func callout(f: Fighter, text: String) -> void:
	hud.callout(f.player, text)


func super_start(f: Fighter, title: String) -> void:
	super_freeze = 40
	hud.super_cutin(f, title)
	Sfx.play("super", 0.0, 1.0, 0.0)
	fx.ring(f.world_point(f.J.neck), Color(1, 0.9, 0.5), 260.0, 30, 10.0)
	fx.speed_lines(f.world_point(f.J.neck), 40, Color(1, 0.95, 0.8, 0.55))
	impact_frame(Color(0, 0, 0), 6, 0.5)


func on_rage(f: Fighter) -> void:
	Sfx.play("rage", -2.0, 1.0, 0.0)
	fx.ring(f.world_point(f.J.neck), Color(1, 0.2, 0.1), 220.0, 24, 8.0)
	hud.callout(f.player, "RAGE MAX!  Super move ready")


func shake(a: float) -> void:
	shake_amt = maxf(shake_amt, a)


func _check_ko() -> void:
	if state != "fight":
		return
	if f1.ko or f2.ko:
		state = "ko"
		st_t = 0
		ko_real = 0.0
		Engine.time_scale = 0.3
		hud.banner("K.O.", 110, 170, Color(1, 0.3, 0.2))
		Sfx.play("ko", 0.0, 1.0, 0.0)
		shake(12.0)
		impact_frame(Color(1, 1, 1), 5, 0.8)
		var loser := f1 if f1.ko else f2
		fx.speed_lines(loser.world_point(loser.J.neck), 50, Color(1, 0.85, 0.7, 0.6))
		zoom_punch = 0.12
		for f in fighters:
			f.locked = true


func _time_over() -> void:
	state = "ko"
	st_t = 0
	ko_real = 1.3
	hud.banner("TIME!", 90, 140, Color(1, 0.8, 0.3))
	for f in fighters:
		f.locked = true
	var r1 := f1.hp / f1.cd.max_hp
	var r2 := f2.hp / f2.cd.max_hp
	if r1 > r2:
		f2.ko = true
		f2.set_state("ko_down")
		f2.play_pose("lose", 10)
	elif r2 > r1:
		f1.ko = true
		f1.set_state("ko_down")
		f1.play_pose("lose", 10)
	else:
		f1.ko = true
		f2.ko = true


func _round_won() -> void:
	state = "round_end"
	st_t = 0
	Engine.time_scale = 1.0
	if f1.ko and f2.ko:
		winner = null
		hud.banner("DRAW", 120, 130)
		return
	winner = f2 if f1.ko else f1
	winner.wins += 1
	winner.set_state("win")
	winner.vel = Vector2.ZERO
	winner.play("win", [[14, winner.cd.pose("win")]])
	var perfect: bool = winner.hp >= winner.cd.max_hp
	hud.banner("%s WINS" % winner.cd.display_name, 130, 96, Color(1, 0.92, 0.6), "PERFECT!" if perfect else "")
	Sfx.play("win", 0.0, 1.0, 0.0)


func _match_end() -> void:
	state = "match_end"
	st_t = 0
	hud.banner(winner.cd.display_name, 9999, 110, Color(1, 0.85, 0.3), "\"%s\"" % winner.cd.quote)
	if Game.mode == "demo":
		return
	menu = Menu.new()
	menu.title = ""
	menu.items = ["REMATCH", "CHARACTER SELECT", "TITLE"]
	menu.y0 = 470.0
	menu.chosen.connect(_on_end_menu)
	hud_layer.add_child(menu)


func _on_end_menu(i: int) -> void:
	menu.queue_free()
	menu = null
	match i:
		0:
			f1.wins = 0
			f2.wins = 0
			round_num = 1
			hud.banners.clear()
			start_round()
		1:
			get_parent().goto("res://scripts/ui/select.gd")
		2:
			get_parent().goto("res://scripts/ui/title.gd")


func _pause() -> void:
	get_tree().paused = true
	menu = Menu.new()
	menu.title = "PAUSED"
	menu.items = ["RESUME", "MOVE LIST", "CHARACTER SELECT", "TITLE"]
	menu.dim = true
	menu.chosen.connect(_on_pause_menu)
	menu.cancelled.connect(func(): _on_pause_menu(0))
	hud_layer.add_child(menu)


func _on_pause_menu(i: int) -> void:
	if i == 1:
		menu.show_moves(f1.cd, f2.cd)
		return
	menu.queue_free()
	menu = null
	get_tree().paused = false
	match i:
		2:
			get_parent().goto("res://scripts/ui/select.gd")
		3:
			get_parent().goto("res://scripts/ui/title.gd")


# ---------------------------------------------------------------- camera

func _camera() -> void:
	var mid := (f1.position.x + f2.position.x) * 0.5
	var dist := absf(f1.position.x - f2.position.x)
	var z := clampf(1280.0 / (dist + 560.0), 0.86, 1.1) + zoom_punch
	zoom_punch = maxf(0.0, zoom_punch - 0.004)
	var vis_half := 640.0 / z
	var tx := clampf(mid, -HALF + vis_half, HALF - vis_half)
	var top := minf(f1.position.y, f2.position.y)
	var ty := -300.0 / z + minf(0.0, top + 120.0) * 0.35
	var cz := lerpf(cam.zoom.x, z, 0.12)
	cam.zoom = Vector2(cz, cz)
	cam.position = Vector2(lerpf(cam.position.x, tx, 0.2), lerpf(cam.position.y, ty, 0.15))
	if shake_amt > 0.1:
		cam.offset = Vector2(randf_range(-1, 1), randf_range(-1, 1)) * shake_amt
		shake_amt *= 0.86
	else:
		cam.offset = Vector2.ZERO
	stage.follow(cam.position)


# ---------------------------------------------------------------- automated test hooks

func _debug_hooks() -> void:
	if debug.is_empty():
		return
	if debug.has("shots"):
		var shots: PackedStringArray = String(debug.shots).split(",")
		if str(frame) in shots:
			var path: String = String(debug.get("shot", "/tmp/fight.png")).replace(".png", "_%d.png" % frame)
			get_viewport().get_texture().get_image().save_png(path)
	if debug.has("quit") and frame >= int(debug.quit):
		print("STATE f1=%s hp=%d  f2=%s hp=%d  wins %d-%d" % [f1.state, f1.hp, f2.state, f2.hp, f1.wins, f2.wins])
		get_tree().quit()


func _exit_tree() -> void:
	CharData.rim = Color(1.0, 0.82, 0.6, 0.45)
