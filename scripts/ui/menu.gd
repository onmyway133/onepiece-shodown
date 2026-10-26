extends Control
## Simple vertical menu used for pause, end of match and title screens.

signal chosen(index: int)
signal cancelled

var title := ""
var items: Array = []
var index := 0
var dim := false
var y0 := 300.0
var t := 0
var moves_view: Array = []


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	set_anchors_preset(Control.PRESET_FULL_RECT)
	size = Vector2(1280, 720)
	mouse_filter = Control.MOUSE_FILTER_IGNORE


static func pressed_any(acts: Array) -> bool:
	for a in acts:
		if Input.is_action_just_pressed(a):
			return true
	return false


func _process(_d: float) -> void:
	t += 1
	queue_redraw()
	if t < 3:
		return
	if not moves_view.is_empty():
		if pressed_any(["ui_accept", "ui_cancel", "p1_light", "p2_light", "pause"]):
			moves_view = []
			Sfx.play("menu_back", -6.0)
		return
	if pressed_any(["ui_up", "p1_up", "p2_up"]):
		index = (index - 1 + items.size()) % items.size()
		Sfx.play("menu_move", -8.0)
	elif pressed_any(["ui_down", "p1_down", "p2_down"]):
		index = (index + 1) % items.size()
		Sfx.play("menu_move", -8.0)
	elif pressed_any(["ui_accept", "p1_light", "p2_light"]):
		Sfx.play("menu_ok", -4.0)
		chosen.emit(index)
	elif pressed_any(["ui_cancel"]):
		cancelled.emit()


func show_moves(a: CharData, b: CharData) -> void:
	moves_view = [a, b]
	t = 0


static func move_lines(cd: CharData) -> Array:
	var out := []
	var names := {"s1": "QCF + Attack   or  Special", "s1_h": "QCF + Heavy   or  Back + Special", "s2": "QCB + Attack   or  Forward + Special",
		"s2_h": "QCB + Heavy", "s3": "DP + Attack   or  Up + Special", "s3_h": "DP + Heavy", "s4": "HCF + Attack   or  Down + Special",
		"super": "Super button (rage MAX)", "super2": "Back + Super (rage MAX)", "throw": "Close: Forward or Back + Heavy"}
	for k in ["s1", "s1_h", "s2", "s2_h", "s3", "s3_h", "s4", "super", "super2", "throw"]:
		if cd.moves.has(k):
			out.append([String(cd.moves[k].get("title", k)), names[k]])
	return out


func _draw() -> void:
	var font := Game.font("display")
	if dim:
		draw_rect(Rect2(0, 0, 1280, 720), Color(0, 0, 0, 0.6))
	if not moves_view.is_empty():
		_draw_moves(font)
		return
	if title != "":
		_text(font, Vector2(0, y0 - 40), title, 72, Color(1, 0.85, 0.3), 1280.0)
	for i in items.size():
		var sel := i == index
		var y := y0 + 30.0 + i * 54.0
		if sel:
			var pulse := 0.5 + 0.5 * sin(t * 0.15)
			draw_colored_polygon(PackedVector2Array([Vector2(440, y - 38), Vector2(860, y - 38), Vector2(840, y + 10), Vector2(420, y + 10)]), Color(0.7, 0.08, 0.08, 0.75 + 0.2 * pulse))
		_text(font, Vector2(0, y), String(items[i]), 40 if sel else 34, Color(1, 1, 1) if sel else Color(0.8, 0.8, 0.8), 1280.0)


func _text(font: Font, pos: Vector2, s: String, size: int, c: Color, w: float, al := HORIZONTAL_ALIGNMENT_CENTER) -> void:
	draw_string_outline(font, pos, s, al, w, size, 8, Color(0.05, 0.02, 0.04, c.a))
	draw_string(font, pos, s, al, w, size, c)


func _draw_moves(font: Font) -> void:
	draw_rect(Rect2(40, 40, 1200, 640), Color(0.06, 0.03, 0.05, 0.92))
	_text(font, Vector2(0, 100), "MOVE LIST", 54, Color(1, 0.85, 0.3), 1280.0)
	var body := Game.font("body")
	for k in 2:
		var cd: CharData = moves_view[k]
		var x := 80.0 + k * 600.0
		_text(font, Vector2(x, 160), cd.display_name, 40, cd.accent.lightened(0.3), 520.0, HORIZONTAL_ALIGNMENT_LEFT)
		var y := 205.0
		for line in move_lines(cd):
			draw_string(body, Vector2(x, y), line[0], HORIZONTAL_ALIGNMENT_LEFT, 540, 20, Color(1, 0.9, 0.6))
			draw_string(body, Vector2(x + 16, y + 19), line[1], HORIZONTAL_ALIGNMENT_LEFT, 540, 16, Color(0.85, 0.85, 0.9))
			y += 40.0
	var help := "Light / Heavy / Kick: normal attacks.   Hold back to block (crouch for low).   Tap forward twice to dash.\nQCF = down, down-forward, forward.   QCB = down, down-back, back.   DP = forward, down, down-forward.   HCF = back, down, forward."
	draw_multiline_string(body, Vector2(80, 625), help, HORIZONTAL_ALIGNMENT_LEFT, 1120, 18, -1, Color(0.8, 0.8, 0.85))
