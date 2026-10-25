class_name Fighter
extends Node2D
## One fighter: state machine, physics, attacks and reactions.
## The Fight node ticks fighters at 60 Hz and resolves hits between them.

const Rig := preload("res://scripts/fight/rig.gd")
const GRAVITY := 0.95
const NEUTRAL := ["idle", "walk_f", "walk_b", "crouch", "guard_hold"]
const RAGE_TIME := 720

var cd: CharData
var player := 1
var facing := 1
var vel := Vector2.ZERO
var opp: Fighter
var fight: Node
var ctrl: Object
var buf := InputBuffer.new()
var locked := true

var state := "idle"
var sf := 0
var stun := 0
var move := {}
var mf := 0
var hit_done := {}
var connected := false
var air_used := false

var hp := 1000.0
var rage := 0.0
var rage_mode := 0
var juggle := 0
var combo := 0
var invuln := 0
var hitstop := 0
var ko := false
var wins := 0

var pose := {}
var J := {}
var anim := []
var anim_t := 0
var anim_total := 0
var anim_from := {}
var anim_loop := false
var anim_key := ""
var trail := []
var flash := 0.0
var rig: Node2D
var input := {}
var time := 0.0


func setup(data: CharData, p: int, controller: Object) -> void:
	cd = data
	player = p
	ctrl = controller
	rig = Rig.new()
	rig.cd = cd
	add_child(rig)
	hp = cd.max_hp
	pose = cd.pose("idle")
	input = Controls.empty()
	reset_round(0.0)


func reset_round(x: float) -> void:
	position = Vector2(x, 0)
	vel = Vector2.ZERO
	hp = cd.max_hp
	ko = false
	state = "intro"
	sf = 0
	stun = 0
	juggle = 0
	combo = 0
	invuln = 0
	hitstop = 0
	move = {}
	trail.clear()
	buf.clear()
	locked = true
	play("intro", [[20, cd.pose("intro")]])
	anim_t = 20
	pose = cd.pose("intro")
	_refresh()


# ---------------------------------------------------------------- animation

func play(key: String, keys: Array, loop := false) -> void:
	if key == anim_key and anim_loop and loop:
		return
	anim_from = pose.duplicate()
	anim = keys
	anim_t = 0
	anim_total = 0
	for k in keys:
		anim_total += int(k[0])
	anim_loop = loop
	anim_key = key


func play_pose(name: String, dur := 5) -> void:
	play(name, [[dur, cd.pose(name)]])


func _anim_step() -> void:
	anim_t += 1
	if anim_loop and anim_t > anim_total:
		anim_from = pose.duplicate()
		anim_t = 1
	var t := mini(anim_t, anim_total)
	var acc := 0
	var prev: Dictionary = anim_from
	for k in anim:
		var d: int = k[0]
		if t <= acc + d:
			var u := float(t - acc) / float(d)
			u = 1.0 - (1.0 - u) * (1.0 - u)
			pose = CharData.lerp_pose(prev, k[1], u)
			return
		acc += d
		prev = k[1]
	pose = prev


func _loop_idle() -> void:
	play("idle", [[32, cd.pose("idle_b")], [32, cd.pose("idle")]], true)


func _loop_walk(back: bool) -> void:
	var a := cd.pose("walk1")
	var b := cd.pose("walk2")
	if back:
		play("walk_b", [[10, b], [10, a]], true)
	else:
		play("walk_f", [[9, a], [9, b]], true)


# ---------------------------------------------------------------- helpers

func on_ground() -> bool:
	return position.y >= -0.01


func world_point(p: Vector2) -> Vector2:
	return position + Vector2(p.x * facing, p.y)


func set_state(s: String) -> void:
	state = s
	sf = 0


func face_opponent() -> void:
	if opp and absf(opp.position.x - position.x) > 4.0:
		facing = 1 if opp.position.x > position.x else -1


func damage_mult() -> float:
	return 1.3 if rage_mode > 0 else 1.0


func can_super() -> bool:
	return rage_mode > 0


func hittable() -> bool:
	if invuln > 0 or state in ["down", "getup", "ko_down", "win", "intro"]:
		return false
	if state == "air_hit" and juggle >= 4:
		return false
	if state == "attack" and move.has("invuln"):
		var iv: Array = move.invuln
		if mf >= iv[0] and mf <= iv[1]:
			return false
	return true


func is_attacking() -> bool:
	return state == "attack"


func is_airborne() -> bool:
	return not on_ground()


# ---------------------------------------------------------------- tick

func tick() -> void:
	time += 1.0 / 60.0
	if locked or ctrl == null:
		input = Controls.empty()
	else:
		input = ctrl.get_input(self)
	buf.push(input, facing)
	if hitstop > 0:
		hitstop -= 1
		_refresh()
		return
	sf += 1
	if invuln > 0:
		invuln -= 1
	if rage_mode > 0:
		rage_mode -= 1
		rage = 100.0 * rage_mode / RAGE_TIME
		if rage_mode == 0:
			rage = 0.0
	flash = maxf(0.0, flash - 0.25)
	_logic()
	_physics()
	_anim_step()
	_refresh()
	if fight:
		cd.update_fx(self, fight.fx)


func _refresh() -> void:
	var grounded := on_ground() and state not in ["air", "air_hit", "prejump_air"]
	if state == "attack" and move.get("air", false):
		grounded = false
	J = cd.joints(pose, grounded)
	# motion trail of the attacking limb
	if state == "attack" and move.has("trail") and hitstop == 0:
		var tp := cd.trail_points(String(move.trail), J)
		if tp.size() == 2:
			trail.append([world_point(tp[0]), world_point(tp[1])])
			if trail.size() > 7:
				trail.pop_front()
	elif trail.size() > 0 and hitstop == 0:
		trail.pop_front()
	rig.scale.x = facing
	rig.pose = pose
	rig.J = J
	var tint: Color = cd.tint_for(pose)
	if rage_mode > 0 and tint.a == 0.0:
		tint = Color(1.0, 0.1, 0.05, 0.12 + 0.08 * sin(time * 12.0))
	rig.st = {"flash": flash, "tint": tint, "time": time, "rage": rage_mode > 0}
	rig.queue_redraw()


func _logic() -> void:
	match state:
		"intro":
			pass
		"idle", "walk_f", "walk_b", "crouch", "guard_hold":
			if combo > 0:
				combo = 0
			juggle = 0
			_neutral()
		"prejump":
			if sf >= 4:
				var xr: int = int(input.x) * facing
				vel = Vector2(xr * cd.jump_vx * facing, cd.jump_vy)
				position.y = -1.0
				air_used = false
				set_state("air")
				play("jump", [[8, cd.pose("jump_up")], [14, cd.pose("jump")]])
				Sfx.play("jump", -6.0)
		"air":
			if not air_used and _try_air_attack():
				return
		"land":
			if sf >= 5:
				set_state("idle")
				_neutral()
		"dash":
			if sf > 5 and _try_attack():
				return
			if sf >= 16:
				set_state("idle")
		"backdash":
			if sf >= 18:
				set_state("idle")
		"attack":
			_attack_logic()
		"hit", "block":
			if sf >= stun:
				set_state("crouch" if input.y < 0 else "idle")
				_neutral()
		"down":
			if sf >= 36:
				set_state("getup")
				invuln = 22
				play_pose("getup", 10)
		"getup":
			if sf >= 20:
				set_state("idle")
				_loop_idle()
		"win", "lose", "ko_down", "air_hit":
			pass


func _neutral() -> void:
	face_opponent()
	if _try_attack():
		return
	var xr: int = int(input.x) * facing
	if input.y > 0:
		set_state("prejump")
		vel.x = 0.0
		play_pose("crouch", 4)
		return
	if buf.dash(1):
		set_state("dash")
		vel.x = cd.dash_speed * facing
		play_pose("dash", 5)
		Sfx.play("dash", -4.0)
		if fight:
			fight.fx.dust(position, -facing)
		return
	if buf.dash(-1):
		set_state("backdash")
		vel = Vector2(-11.0 * facing, 0)
		invuln = 8
		play_pose("backdash", 5)
		Sfx.play("dash", -4.0)
		return
	if input.y < 0:
		if state != "crouch":
			set_state("crouch")
		vel.x = 0.0
		if anim_key != "crouch":
			play("crouch", [[5, cd.pose("crouch")]])
	elif xr > 0:
		if state != "walk_f":
			set_state("walk_f")
		vel.x = cd.walk_speed * facing
		_loop_walk(false)
	elif xr < 0:
		if opp and opp.is_threatening(self):
			if state != "guard_hold":
				set_state("guard_hold")
				play_pose("guard", 4)
			vel.x = 0.0
		else:
			if state != "walk_b":
				set_state("walk_b")
			vel.x = -cd.back_speed * facing
			_loop_walk(true)
	else:
		if state != "idle":
			set_state("idle")
		vel.x = 0.0
		_loop_idle()


## True while this fighter has an attack coming that `other` should guard against.
func is_threatening(other: Fighter) -> bool:
	if state == "attack":
		return absf(other.position.x - position.x) < 420.0
	if fight:
		for pr in fight.projectiles:
			if pr.owner_f == self and absf(pr.position.x - other.position.x) < 380.0:
				return true
	return false


# ---------------------------------------------------------------- attacks

func _super_input() -> bool:
	if input.super:
		return true
	if input.special and input.heavy_held:
		return true
	if (input.light or input.heavy or input.kick) and buf.motion([2, 3, 6, 2, 3, 6], 30):
		return true
	return false


func _special_name() -> String:
	var any_btn: bool = input.light or input.heavy or input.kick
	var m := ""
	if any_btn:
		if buf.motion([6, 2, 3], 16):
			m = "s3"
		elif buf.motion([2, 3, 6], 16):
			m = "s1"
		elif buf.motion([2, 1, 4], 16):
			m = "s2"
		if m != "" and input.heavy and cd.moves.has(m + "_h"):
			m += "_h"
	if m == "" and input.special:
		var xr: int = int(input.x) * facing
		if input.y > 0:
			m = "s3"
		elif xr > 0:
			m = "s2"
		elif xr < 0 and cd.moves.has("s1_h"):
			m = "s1_h"
		else:
			m = "s1"
	return m


func _try_attack(cancel := false) -> bool:
	if not on_ground():
		return false
	if _super_input() and can_super() and cd.moves.has("super"):
		start_move("super")
		return true
	var sp := _special_name()
	if sp != "" and cd.moves.has(sp):
		start_move(sp)
		return true
	if cancel:
		var chain: Array = move.get("chain", [])
		var low: bool = input.y < 0
		for b in ["heavy", "kick"]:
			if input[b]:
				var n: String = ("c_" + b) if low else b
				if n in chain:
					start_move(n)
					return true
		return false
	var crouching: bool = input.y < 0
	var pre := "c_" if crouching else ""
	for b in ["heavy", "kick", "light"]:
		if input[b] and cd.moves.has(pre + b):
			start_move(pre + b)
			return true
	return false


func _try_air_attack() -> bool:
	for b in ["heavy", "kick", "light"]:
		if input[b] and cd.moves.has("j_" + b):
			air_used = true
			start_move("j_" + b)
			return true
	return false


func start_move(name: String) -> void:
	if on_ground():
		face_opponent()
	move = cd.moves[name]
	mf = 0
	hit_done.clear()
	connected = false
	set_state("attack")
	play("move_" + name, move["keys"])
	if move.get("super", false):
		rage_mode = 0
		rage = 0.0
		if fight:
			fight.super_start(self, String(move.get("title", "")))
	elif move.has("title") and fight:
		fight.callout(self, String(move.title))
	if not move.get("air", false) and on_ground() and not move.has("vel"):
		vel.x = 0.0


func _attack_logic() -> void:
	mf += 1
	for ev in move.get("vel", []):
		if int(ev[0]) == mf:
			vel.x = float(ev[1]) * facing
			if ev.size() > 2:
				vel.y = float(ev[2])
				if vel.y < 0.0 and on_ground():
					position.y = -1.0
	for ev in move.get("sfx", []):
		if int(ev[0]) == mf:
			Sfx.play(String(ev[1]))
	if fight:
		for ev in move.get("proj", []):
			if int(ev[0]) == mf:
				fight.spawn_projectile(self, ev[1])
		for ev in move.get("fx", []):
			if int(ev[0]) == mf:
				var off: Array = ev[2] if ev.size() > 2 else [0, -120]
				fight.fx.burst(String(ev[1]), world_point(Vector2(off[0], off[1])), facing)
		for ev in move.get("shake_at", []):
			if int(ev[0]) == mf:
				fight.shake(float(ev[1]))
	if connected and move.get("cancel", false) and mf <= _last_active() + 14:
		if _try_attack(true):
			return
	if move.get("air", false) and on_ground() and mf > 2:
		_end_move(true)
		return
	if mf >= int(move.total):
		_end_move(false)


func _last_active() -> int:
	var last := 0
	for h in move.hits:
		last = maxi(last, int(h.f[1]))
	return last


func _end_move(landed: bool) -> void:
	var was_crouch: bool = move.get("crouch", false)
	move = {}
	if not on_ground():
		set_state("air")
		air_used = true
		play("jump", [[10, cd.pose("jump")]])
	elif landed:
		set_state("land")
		play_pose("land", 4)
	elif was_crouch and input.y < 0:
		set_state("crouch")
		play("crouch", [[4, cd.pose("crouch")]])
	else:
		set_state("idle")
		_loop_idle()


## Hits whose active window includes this frame: [{h, a, b, r}] in world space.
func active_hits() -> Array:
	var out := []
	if state != "attack" or hitstop > 0:
		return out
	for h in move.hits:
		if hit_done.has(h.id):
			continue
		if mf >= int(h.f[0]) and mf <= int(h.f[1]):
			var seg := cd.hit_seg(h, J)
			out.append({"h": h, "a": world_point(seg[0]), "b": world_point(seg[1]), "r": seg[2]})
	return out


func hurt_world() -> Array:
	var out := []
	for c in cd.hurt_caps(J):
		out.append([world_point(c[0]), world_point(c[1]), c[2]])
	return out


# ---------------------------------------------------------------- getting hit

func can_block(h: Dictionary, from_x: float) -> bool:
	if not on_ground() or not (state in NEUTRAL or state == "block" or state == "land"):
		return false
	var away := -1 if from_x > position.x else 1
	if int(input.x) != away:
		return false
	var low: bool = input.y < 0
	if h.lvl == "low" and not low:
		return false
	if h.lvl == "high" and low:
		return false
	return true


## Returns true when the hit landed, false when it was blocked.
func take_hit(atk_x: float, h: Dictionary, mult := 1.0) -> bool:
	var dirx := 1.0 if position.x > atk_x else -1.0
	if can_block(h, atk_x):
		var low: bool = input.y < 0
		set_state("block")
		stun = int(h.bstun)
		vel.x = dirx * float(h.kb) * 0.9
		hp = maxf(1.0, hp - float(h.dmg) * float(h.chip) * mult)
		add_rage(3.0)
		play_pose("guard_low" if low else "guard", 3)
		hitstop = maxi(4, int(h.hs) - 3)
		return false
	combo += 1
	var scale := maxf(0.4, 1.0 - 0.1 * (combo - 1))
	var dmg := float(h.dmg) * mult * scale
	hp -= dmg
	add_rage(dmg * 0.16)
	flash = 1.0
	hitstop = int(h.hs)
	move = {}
	if hp <= 0.0:
		hp = 0.0
		ko = true
	var lift: float = h.lift
	if ko or h.kd or lift != 0.0 or not on_ground():
		set_state("air_hit")
		juggle += 1
		vel.x = dirx * maxf(float(h.kb), 4.0)
		vel.y = lift if lift != 0.0 else -7.0
		if ko:
			vel = Vector2(dirx * 7.5, -13.0)
		if on_ground():
			position.y = -1.0
		facing = -int(dirx)
		play("air_hurt", [[6, cd.pose("air_hurt")]])
	else:
		set_state("hit")
		stun = int(h.stun)
		vel.x = dirx * float(h.kb)
		var crouched: bool = input.y < 0 and anim_key in ["crouch", "move_c_light", "move_c_heavy", "move_c_kick"]
		var hp_pose := "hurt_low" if crouched else ("hurt" if combo % 2 == 1 else "hurt2")
		play("hurt", [[3, cd.pose(hp_pose)], [maxi(4, stun - 3), cd.pose("crouch" if crouched else "idle")]])
	return true


func add_rage(v: float) -> void:
	if rage_mode > 0:
		return
	rage = minf(100.0, rage + v)
	if rage >= 100.0:
		rage_mode = RAGE_TIME
		if fight:
			fight.on_rage(self)


# ---------------------------------------------------------------- physics

func _physics() -> void:
	var airborne := not on_ground()
	if airborne:
		var g := GRAVITY
		if state == "attack" and move.has("grav"):
			g *= float(move.grav)
		vel.y += g
	position += vel
	if position.y >= 0.0 and (airborne or vel.y > 0.0):
		position.y = 0.0
		var vy := vel.y
		vel.y = 0.0
		_landed(vy)
	elif not airborne:
		position.y = 0.0
		var slide: bool = state == "attack" and move.get("slide", false)
		if not slide and state in ["hit", "block", "dash", "backdash", "attack", "land", "getup", "down", "ko_down"]:
			vel.x *= 0.86 if state != "dash" else 0.9
			if absf(vel.x) < 0.1:
				vel.x = 0.0


func _landed(vy: float) -> void:
	match state:
		"air":
			set_state("land")
			vel.x = 0.0
			play_pose("land", 4)
			Sfx.play("land", -8.0)
		"air_hit":
			vel.x *= 0.4
			if fight:
				fight.fx.dust(position, 0)
				fight.shake(4.0)
			Sfx.play("thud", -2.0)
			if vy > 9.0 and juggle < 6:
				juggle += 1
				vel.y = -vy * 0.3
				position.y = -1.0
				return
			set_state("ko_down" if ko else "down")
			play("down", [[6, cd.pose("down")]])
		"attack":
			pass
		"prejump":
			pass
