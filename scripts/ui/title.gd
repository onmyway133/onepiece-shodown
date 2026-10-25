extends Control
## Title screen with the main menu.

const Rig := preload("res://scripts/fight/rig.gd")
const Menu := preload("res://scripts/ui/menu.gd")

var menu: Control
var rigs: Array = []
var t := 0.0
var show_controls := false
var idle_time := 0.0
var bg: Texture2D


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	size = Vector2(1280, 720)
	if ResourceLoader.exists("res://assets/ui/title_bg.png"):
		bg = load("res://assets/ui/title_bg.png")
	_add_rig("luffy", Vector2(250, 760), 1.9, 1, {"base": "idle", "ua_f": 95.0, "fa_f": 95.0, "st_f": 1.3, "t": 16.0, "face": "grin"})
	_add_rig("zoro", Vector2(1040, 760), 1.9, -1, "idle")
	menu = Menu.new()
	menu.items = ["VS CPU", "VS PLAYER 2", "TRAINING", _level_text(), "CONTROLS", "QUIT"]
	menu.y0 = 360.0
	menu.chosen.connect(_on_choice)
	add_child(menu)
	Sfx.music("menu")


func _add_rig(id: String, pos: Vector2, sc: float, facing: int, pose) -> void:
	var r := Rig.new()
	r.cd = Game.char_data(id)
	r.position = pos
	r.scale = Vector2(sc * facing, sc)
	r.st = {"time": 0.0, "tint": Color(0.05, 0.0, 0.08, 0.35)}
	r.set_meta("pose", pose)
	add_child(r)
	r.set_pose(r.cd.pose(pose))
	rigs.append(r)


func _level_text() -> String:
	return "CPU LEVEL:  < %s >" % Game.DIFFICULTIES[Game.difficulty]


func _process(delta: float) -> void:
	t += delta
	idle_time += delta
	for r in rigs:
		var base: Dictionary = r.cd.pose(r.get_meta("pose"))
		var b2 := base.duplicate()
		b2.hy = base.get("hy", 0.0) + 4.0
		b2.t = base.t + 3.0
		r.st.time = t
		r.set_pose(CharData.lerp_pose(base, b2, 0.5 + 0.5 * sin(t * 2.4)))
	if show_controls:
		if Menu.pressed_any(["ui_accept", "ui_cancel", "p1_light", "p2_light"]):
			show_controls = false
			menu.visible = true
			menu.set_process(true)
	elif menu.index == 3 and Menu.pressed_any(["ui_left", "p1_left", "p2_left", "ui_right", "p1_right", "p2_right"]):
		var d := 1 if Menu.pressed_any(["ui_right", "p1_right", "p2_right"]) else -1
		Game.difficulty = clampi(Game.difficulty + d, 0, Game.DIFFICULTIES.size() - 1)
		menu.items[3] = _level_text()
		Sfx.play("menu_move", -8.0)
	if Input.is_anything_pressed():
		idle_time = 0.0
	if idle_time > 25.0:
		# attract mode: CPU vs CPU demo
		Game.mode = "demo"
		Game.p1_char = Game.ROSTER[randi() % Game.ROSTER.size()]
		Game.p2_char = Game.ROSTER[randi() % Game.ROSTER.size()]
		Game.stage = Game.STAGES[randi() % Game.STAGES.size()].id
		get_parent().goto("res://scripts/fight/fight.gd", {"demo": true})
		return
	queue_redraw()


func _on_choice(i: int) -> void:
	match i:
		0:
			Game.mode = "cpu"
			get_parent().goto("res://scripts/ui/select.gd")
		1:
			Game.mode = "versus"
			get_parent().goto("res://scripts/ui/select.gd")
		2:
			Game.mode = "training"
			get_parent().goto("res://scripts/ui/select.gd")
		3:
			Game.difficulty = (Game.difficulty + 1) % Game.DIFFICULTIES.size()
			menu.items[3] = _level_text()
		4:
			show_controls = true
			menu.visible = false
			menu.set_process(false)
		5:
			get_tree().quit()


func _draw() -> void:
	if bg:
		draw_texture_rect(bg, Rect2(0, 0, 1280, 720), false)
	var title := Game.font("title")
	var disp := Game.font("display")
	# brush stroke behind the logo
	var y := 170.0
	draw_colored_polygon(PackedVector2Array([Vector2(250, y - 120), Vector2(1060, y - 140), Vector2(1030, y + 30), Vector2(220, y + 50)]), Color(0.65, 0.05, 0.06, 0.85))
	_outlined(disp, Vector2(0, y - 92), "ONE PIECE", 46, Color(1, 0.9, 0.55), 12)
	_outlined(title, Vector2(0, y + 22), "SHODOWN", 112, Color(1, 1, 1), 16)
	_outlined(Game.font("body"), Vector2(0, y + 70), "Grand Line Warriors", 26, Color(1, 0.85, 0.5), 6)
	if show_controls:
		_draw_controls()
	else:
		var a := 0.5 + 0.5 * sin(t * 3.0)
		_outlined(Game.font("body"), Vector2(0, 700), "Enter / F / J to select   ·   Esc to go back", 18, Color(1, 1, 1, 0.5 + a * 0.3), 4)


func _outlined(font: Font, pos: Vector2, s: String, size: int, c: Color, o: int) -> void:
	draw_string_outline(font, pos, s, HORIZONTAL_ALIGNMENT_CENTER, 1280.0, size, o, Color(0.05, 0.02, 0.04, c.a))
	draw_string(font, pos, s, HORIZONTAL_ALIGNMENT_CENTER, 1280.0, size, c)


func _draw_controls() -> void:
	draw_rect(Rect2(140, 250, 1000, 440), Color(0.05, 0.02, 0.05, 0.9))
	var f := Game.font("body")
	var lines := [
		["", "PLAYER 1", "PLAYER 2"],
		["Move / jump / crouch", "W A S D", "Arrow keys"],
		["Light attack", "F  or  J", ",  or  Num 1"],
		["Heavy attack", "G  or  K", ".  or  Num 2"],
		["Kick", "H  or  L", "/  or  Num 3"],
		["Special", "T  or  I", ";  or  Num 4"],
		["Super (rage MAX)", "Y  or  U", "'  or  Num 5"],
		["Gamepad", "Pad 1: X Y A B, RB", "Pad 2: same"],
	]
	for i in lines.size():
		var y := 300.0 + i * 40.0
		var c := Color(1, 0.85, 0.4) if i == 0 else Color(1, 1, 1)
		draw_string(f, Vector2(180, y), lines[i][0], HORIZONTAL_ALIGNMENT_LEFT, 340, 24, c)
		draw_string(f, Vector2(540, y), lines[i][1], HORIZONTAL_ALIGNMENT_LEFT, 300, 24, c)
		draw_string(f, Vector2(850, y), lines[i][2], HORIZONTAL_ALIGNMENT_LEFT, 280, 24, c)
	var help := "Hold back to block, hold down-back to block low. Tap forward twice to dash.\nSpecials: Special button + direction, or classic motions (quarter circle + attack).\nGetting hit fills your RAGE. At MAX you hit harder and can use your Super. Enter / Esc pauses."
	draw_multiline_string(f, Vector2(180, 625), help, HORIZONTAL_ALIGNMENT_LEFT, 940, 19, -1, Color(0.85, 0.85, 0.9))
