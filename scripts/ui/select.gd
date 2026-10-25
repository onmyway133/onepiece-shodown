extends Control
## Character select followed by stage select.

const Rig := preload("res://scripts/fight/rig.gd")

const CARD := Vector2(150, 170)

var cursors := [0, 1]
var picked := [false, false]
var phase := "chars"  # chars, stage
var stage_i := 0
var cards: Array = []
var big: Array = [null, null]
var t := 0.0
var stage_tex: Array = []
var _wait := 3


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	size = Vector2(1280, 720)
	cursors[0] = maxi(0, Game.ROSTER.find(Game.p1_char))
	cursors[1] = maxi(0, Game.ROSTER.find(Game.p2_char))
	var n := Game.ROSTER.size()
	var x0 := 640.0 - n * (CARD.x + 16) / 2.0 + 8.0
	for i in n:
		var clip := Control.new()
		clip.clip_contents = true
		clip.position = Vector2(x0 + i * (CARD.x + 16), 470)
		clip.size = CARD
		add_child(clip)
		var r := Rig.new()
		r.cd = Game.char_data(Game.ROSTER[i])
		r.position = Vector2(CARD.x * 0.5 - 4, 300)
		r.scale = Vector2(1.25, 1.25)
		r.st = {"time": 0.0}
		clip.add_child(r)
		r.set_pose(r.cd.pose("idle"))
		cards.append({"clip": clip, "rig": r})
	for p in 2:
		var r := Rig.new()
		r.position = Vector2(220 if p == 0 else 1060, 440)
		r.scale = Vector2(1.45 * (1 if p == 0 else -1), 1.45)
		r.st = {"time": 0.0}
		add_child(r)
		big[p] = r
	for s in Game.STAGES:
		var layers := []
		for l in ["sky", "far", "mid", "ground"]:
			var path := "res://assets/stages/%s/%s.png" % [s.id, l]
			if ResourceLoader.exists(path):
				layers.append(load(path))
		stage_tex.append(layers)
	stage_i = maxi(0, Game.STAGES.map(func(s): return s.id).find(Game.stage))
	Sfx.music("menu")


func _two_humans() -> bool:
	return Game.mode == "versus"


func _pressed(p: int, a: String) -> bool:
	if p == 0 and not _two_humans():
		return Input.is_action_just_pressed("p1_" + a) or Input.is_action_just_pressed("p2_" + a) or (a == "light" and Input.is_action_just_pressed("ui_accept"))
	return Input.is_action_just_pressed("p%d_%s" % [p + 1, a]) or (p == 0 and a == "light" and Input.is_action_just_pressed("ui_accept"))


func _process(delta: float) -> void:
	t += delta
	if _wait > 0:
		_wait -= 1
		queue_redraw()
		return
	if phase == "chars":
		_chars_input()
	else:
		_stage_input()
	for c in cards:
		c.clip.visible = phase == "chars"
	for p in 2:
		var cd := Game.char_data(Game.ROSTER[cursors[p]])
		var r: Node2D = big[p]
		r.cd = cd
		var a := cd.pose("idle")
		var b := cd.pose("idle_b")
		if picked[p]:
			a = cd.pose("win")
			b = a
		r.st = {"time": t}
		r.set_pose(CharData.lerp_pose(a, b, 0.5 + 0.5 * sin(t * 3.0 + p)))
	for c in cards:
		c.rig.st = {"time": t}
		c.rig.queue_redraw()
	queue_redraw()


func _active_cursor() -> int:
	# in single-player modes P1 picks both fighters in turn
	if _two_humans():
		return -1
	return 0 if not picked[0] else 1


func _chars_input() -> void:
	var n := Game.ROSTER.size()
	if Input.is_action_just_pressed("ui_cancel"):
		if picked[1] and not _two_humans():
			picked[1] = false
		elif picked[0] and not _two_humans():
			picked[0] = false
		else:
			get_parent().goto("res://scripts/ui/title.gd")
			return
		Sfx.play("menu_back", -6.0)
	for p in 2:
		var who := p
		if not _two_humans():
			if p == 1:
				continue
			who = _active_cursor()
		if picked[who]:
			continue
		if _pressed(p, "left"):
			cursors[who] = (cursors[who] - 1 + n) % n
			Sfx.play("menu_move", -8.0)
		elif _pressed(p, "right"):
			cursors[who] = (cursors[who] + 1) % n
			Sfx.play("menu_move", -8.0)
		elif _pressed(p, "light") or _pressed(p, "heavy") or _pressed(p, "kick"):
			picked[who] = true
			Sfx.play("menu_ok", -2.0)
			Sfx.play("swing_h", -6.0)
		if _two_humans() and p == 1 and Input.is_action_just_pressed("p2_special") and picked[1]:
			picked[1] = false
	if picked[0] and picked[1]:
		Game.p1_char = Game.ROSTER[cursors[0]]
		Game.p2_char = Game.ROSTER[cursors[1]]
		phase = "stage"
		_wait = 4


func _stage_input() -> void:
	var n := Game.STAGES.size()
	if Input.is_action_just_pressed("ui_cancel"):
		phase = "chars"
		picked[1] = false
		if _two_humans():
			picked[0] = false
		Sfx.play("menu_back", -6.0)
		return
	if _pressed(0, "left") or Input.is_action_just_pressed("ui_left"):
		stage_i = (stage_i - 1 + n) % n
		Sfx.play("menu_move", -8.0)
	elif _pressed(0, "right") or Input.is_action_just_pressed("ui_right"):
		stage_i = (stage_i + 1) % n
		Sfx.play("menu_move", -8.0)
	elif _pressed(0, "light") or _pressed(0, "heavy"):
		Game.stage = Game.STAGES[stage_i].id
		Sfx.play("menu_ok", -2.0)
		get_parent().goto("res://scripts/fight/fight.gd")


func _draw() -> void:
	# background
	draw_rect(Rect2(0, 0, 1280, 720), Color(0.08, 0.04, 0.08))
	for i in 18:
		var y := i * 44.0 + fmod(t * 30.0, 44.0)
		draw_line(Vector2(0, y), Vector2(1280, y - 220), Color(0.5, 0.1, 0.12, 0.18), 18.0)
	var disp := Game.font("display")
	var body := Game.font("body")
	var head := "SELECT YOUR PIRATE" if phase == "chars" else "SELECT STAGE"
	_text(disp, Vector2(0, 70), head, 54, Color(1, 0.85, 0.3), HORIZONTAL_ALIGNMENT_CENTER, 1280.0)
	if phase == "stage":
		_draw_stage(disp, body)
	for p in 2:
		var cd := Game.char_data(Game.ROSTER[cursors[p]])
		var x := 220.0 if p == 0 else 1060.0
		var tag := "1P" if p == 0 else ("2P" if _two_humans() else "CPU")
		if Game.mode == "training" and p == 1:
			tag = "DUMMY"
		var col := Color(1, 0.3, 0.25) if p == 0 else Color(0.35, 0.6, 1)
		draw_colored_polygon(PackedVector2Array([Vector2(x - 170, 455), Vector2(x + 170, 455), Vector2(x + 150, 505), Vector2(x - 190, 505)]), Color(0, 0, 0, 0.55))
		_text(disp, Vector2(x - 170, 495), cd.display_name, 44, Color(1, 1, 1), HORIZONTAL_ALIGNMENT_CENTER, 340.0)
		_text(body, Vector2(x - 170, 530), cd.epithet, 22, cd.accent.lightened(0.4), HORIZONTAL_ALIGNMENT_CENTER, 340.0)
		_text(disp, Vector2(x - 170, 580), tag, 34, col, HORIZONTAL_ALIGNMENT_CENTER, 340.0)
		if picked[p]:
			_text(disp, Vector2(x - 170, 620), "READY!", 30, Color(1, 0.9, 0.4), HORIZONTAL_ALIGNMENT_CENTER, 340.0)
	if phase == "chars":
		for i in cards.size():
			var c: Control = cards[i].clip
			var r := Rect2(c.position, c.size)
			draw_rect(r.grow(4), Color(0.15, 0.1, 0.12))
			var acc: Color = cards[i].rig.cd.accent
			draw_rect(r, acc.darkened(0.55))
			for p in 2:
				if cursors[p] == i:
					var col := Color(1, 0.3, 0.25) if p == 0 else Color(0.35, 0.6, 1)
					var g := 6.0 + 2.0 * sin(t * 8.0) + p * 6.0
					draw_rect(r.grow(g), col, false, 4.0)
			_text(disp, Vector2(r.position.x, r.end.y + 30), cards[i].rig.cd.display_name, 24, Color(1, 1, 1), HORIZONTAL_ALIGNMENT_CENTER, r.size.x)
		var hint := "← → choose   ·   Light to confirm   ·   Esc back"
		if not _two_humans():
			hint = ("Pick your fighter" if not picked[0] else "Pick your opponent") + "   ·   " + hint
		_text(body, Vector2(0, 700), hint, 20, Color(1, 1, 1, 0.75), HORIZONTAL_ALIGNMENT_CENTER, 1280.0)


func _draw_stage(disp: Font, body: Font) -> void:
	var r := Rect2(390, 150, 500, 230)
	draw_rect(r.grow(6), Color(0.85, 0.7, 0.35))
	for tex in stage_tex[stage_i]:
		# crop around the fighting area of each 2400x1100 layer
		draw_texture_rect_region(tex, r, Rect2(500, 260, 1400, 640))
	_text(disp, Vector2(0, 425), "<  " + Game.STAGES[stage_i].name + "  >", 36, Color(1, 1, 1), HORIZONTAL_ALIGNMENT_CENTER, 1280.0)
	_text(body, Vector2(0, 700), "← → choose stage   ·   Light to fight!   ·   Esc back", 20, Color(1, 1, 1, 0.75), HORIZONTAL_ALIGNMENT_CENTER, 1280.0)


func _text(font: Font, pos: Vector2, s: String, size: int, c: Color, al: int, w: float) -> void:
	draw_string_outline(font, pos, s, al, w, size, 8, Color(0.05, 0.02, 0.04, c.a))
	draw_string(font, pos, s, al, w, size, c)
