extends Control
## Fight HUD: health, rage (POW) gauges, timer, round markers, combo counter,
## banners ("ROUND 1", "K.O."), special move call-outs and the super cut-in.

const Rig := preload("res://scripts/fight/rig.gd")

var fight
var f1
var f2
var lag := [1.0, 1.0]
var shown := [1.0, 1.0]
var banners: Array = []
var callouts: Array = []
var combos := [{"n": 0, "t": 0}, {"n": 0, "t": 0}]
var cutin := {}
var cut_rig: Node2D
var t := 0.0
var dark := 0.0


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	size = Vector2(1280, 720)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	cut_rig = Rig.new()
	cut_rig.visible = false
	add_child(cut_rig)


func setup(fi, a, b) -> void:
	fight = fi
	f1 = a
	f2 = b


func banner(text: String, dur := 60, size := 110, col := Color(1, 0.92, 0.6), sub := "") -> void:
	banners.append({"text": text, "t": 0, "dur": dur, "size": size, "col": col, "sub": sub})


func callout(p: int, text: String) -> void:
	callouts = callouts.filter(func(c): return c.p != p)
	callouts.append({"p": p, "text": text, "t": 0, "dur": 70})


func combo(p: int, n: int) -> void:
	combos[p - 1] = {"n": n, "t": 0}


func super_cutin(f, title: String) -> void:
	cutin = {"f": f, "title": title, "t": 0, "dur": 42}
	cut_rig.cd = f.cd
	var p: Dictionary = f.cd.pose("shout")
	p = p.duplicate()
	p.face = "shout"
	cut_rig.st = {"time": 0.0, "tint": f.cd.tint_for(f.pose)}
	cut_rig.set_pose(p, true)
	cut_rig.visible = true


func _process(delta: float) -> void:
	t += delta
	for i in 2:
		var f = f1 if i == 0 else f2
		if f == null:
			continue
		var target: float = f.hp / f.cd.max_hp
		shown[i] = move_toward(shown[i], target, delta * 2.5)
		if lag[i] > shown[i]:
			lag[i] = move_toward(lag[i], shown[i], delta * 0.45)
		else:
			lag[i] = shown[i]
	for b in banners:
		b.t += 1
	banners = banners.filter(func(b): return b.t < b.dur)
	for c in callouts:
		c.t += 1
	callouts = callouts.filter(func(c): return c.t < c.dur)
	for c in combos:
		c.t += 1
	if not cutin.is_empty():
		cutin.t += 1
		var u: float = float(cutin.t) / cutin.dur
		var side: int = 1 if cutin.f.player == 1 else -1
		var x := 300.0 if side == 1 else 980.0
		cut_rig.position = Vector2(x - side * 400.0 * pow(maxf(0.0, 1.0 - u * 4.0), 2.0), 760)
		cut_rig.scale = Vector2(2.6 * side, 2.6)
		cut_rig.modulate.a = 1.0 if u < 0.85 else (1.0 - u) / 0.15
		if cutin.t >= cutin.dur:
			cutin = {}
			cut_rig.visible = false
	dark = move_toward(dark, 0.6 if not cutin.is_empty() else 0.0, delta * 6.0)
	queue_redraw()


func _draw() -> void:
	var font := Game.font("display")
	if dark > 0.0:
		draw_rect(Rect2(0, 0, 1280, 720), Color(0.05, 0.0, 0.08, dark))
	if not cutin.is_empty():
		_draw_cutin(font)
	if f1 == null:
		return
	_draw_bar(font, f1, 0)
	_draw_bar(font, f2, 1)
	_draw_timer(font)
	_draw_rage(font, f1, 0)
	_draw_rage(font, f2, 1)
	for i in 2:
		var c: Dictionary = combos[i]
		if c.n >= 2 and c.t < 70:
			var a: float = 1.0 if c.t < 50 else (70 - c.t) / 20.0
			var x := 60.0 if i == 0 else 1220.0
			var al := HORIZONTAL_ALIGNMENT_LEFT if i == 0 else HORIZONTAL_ALIGNMENT_RIGHT
			var px := x if i == 0 else x - 300.0
			_text(font, Vector2(px, 250), "%d" % c.n, 64, Color(1, 0.85, 0.2, a), al, 300.0)
			_text(font, Vector2(px, 285), "HITS!", 30, Color(1, 1, 1, a), al, 300.0)
	for c in callouts:
		_draw_callout(font, c)
	for b in banners:
		_draw_banner(font, b)


func _text(font: Font, pos: Vector2, s: String, size: int, c: Color, al := HORIZONTAL_ALIGNMENT_LEFT, w := -1.0, outline := 8) -> void:
	draw_string_outline(font, pos, s, al, w, size, outline, Color(0.05, 0.02, 0.04, c.a))
	draw_string(font, pos, s, al, w, size, c)


func _draw_bar(font: Font, f, i: int) -> void:
	var w := 500.0
	var h := 26.0
	var y := 34.0
	var x0 := 70.0 if i == 0 else 1280.0 - 70.0 - w
	var sk := 14.0
	var frame := PackedVector2Array([Vector2(x0 - 6, y - 6), Vector2(x0 + w + 6 + sk, y - 6), Vector2(x0 + w + 6, y + h + 6), Vector2(x0 - 6 - sk, y + h + 6)])
	draw_colored_polygon(frame, Color(0.08, 0.05, 0.06))
	draw_polyline(frame + PackedVector2Array([frame[0]]), Color(0.85, 0.7, 0.35), 2.0, true)
	var base := PackedVector2Array([Vector2(x0, y), Vector2(x0 + w + sk, y), Vector2(x0 + w, y + h), Vector2(x0 - sk, y + h)])
	draw_colored_polygon(base, Color(0.25, 0.05, 0.05))
	var ratio_lag: float = lag[i]
	var ratio: float = shown[i]
	_fill(x0, y, w, h, sk, ratio_lag, i, Color(1.0, 0.95, 0.9) if f.flash > 0.0 else Color(0.85, 0.12, 0.1))
	var c1 := Color(1.0, 0.86, 0.2)
	var c2 := Color(0.98, 0.6, 0.1)
	if ratio < 0.3:
		var pulse := 0.5 + 0.5 * sin(t * 10.0)
		c1 = c1.lerp(Color(1, 0.3, 0.2), pulse)
	_fill(x0, y, w, h * 0.55, sk * 0.55, ratio, i, c1)
	_fill(x0 - sk * 0.55, y + h * 0.55, w, h * 0.45, sk * 0.45, ratio, i, c2)
	# name
	var nx := x0 if i == 0 else x0 + w - 300.0
	var al := HORIZONTAL_ALIGNMENT_LEFT if i == 0 else HORIZONTAL_ALIGNMENT_RIGHT
	_text(font, Vector2(nx, y + h + 34), f.cd.display_name, 30, Color(1, 1, 1), al, 300.0, 7)
	# round wins
	for k in Game.rounds_to_win:
		var cx := x0 + w - 20.0 - k * 30.0 if i == 0 else x0 + 20.0 + k * 30.0
		var won: bool = k < f.wins
		draw_circle(Vector2(cx, y + h + 22), 10.0, Color(0.1, 0.05, 0.05))
		draw_circle(Vector2(cx, y + h + 22), 7.0, Color(1.0, 0.75, 0.15) if won else Color(0.3, 0.25, 0.25))


func _fill(x0: float, y: float, w: float, h: float, sk: float, ratio: float, i: int, c: Color) -> void:
	if ratio <= 0.001:
		return
	var fw := w * ratio
	var pts: PackedVector2Array
	if i == 0:
		# P1 drains toward the center-left: anchor at the right (center) edge
		var xr := x0 + w
		pts = PackedVector2Array([Vector2(xr - fw + sk, y), Vector2(xr + sk, y), Vector2(xr, y + h), Vector2(xr - fw, y + h)])
	else:
		pts = PackedVector2Array([Vector2(x0, y), Vector2(x0 + fw + sk, y), Vector2(x0 + fw, y + h), Vector2(x0 - sk, y + h)])
	draw_colored_polygon(pts, c)


func _draw_timer(font: Font) -> void:
	var c := Vector2(640, 52)
	draw_circle(c, 44.0, Color(0.08, 0.05, 0.06))
	draw_arc(c, 44.0, 0, TAU, 40, Color(0.85, 0.7, 0.35), 3.0, true)
	var s := "%02d" % fight.time_left
	if Game.mode == "training":
		s = "∞"
	var col := Color(1, 1, 1)
	if fight.time_left <= 10 and Game.mode != "training":
		col = Color(1, 0.4, 0.3)
	_text(font, c + Vector2(-60, 20), s, 56, col, HORIZONTAL_ALIGNMENT_CENTER, 120.0, 8)


func _draw_rage(font: Font, f, i: int) -> void:
	var w := 300.0
	var h := 16.0
	var y := 680.0
	var x0 := 60.0 if i == 0 else 1280.0 - 60.0 - w
	draw_rect(Rect2(x0 - 3, y - 3, w + 6, h + 6), Color(0.08, 0.05, 0.06))
	draw_rect(Rect2(x0, y, w, h), Color(0.2, 0.08, 0.08))
	var r: float = f.rage / 100.0
	var full: bool = f.rage_mode > 0
	var col := Color(0.95, 0.35, 0.1)
	if full:
		col = Color(1, 0.15, 0.1).lerp(Color(1, 0.9, 0.3), 0.5 + 0.5 * sin(t * 14.0))
	if i == 0:
		draw_rect(Rect2(x0, y, w * r, h), col)
	else:
		draw_rect(Rect2(x0 + w * (1.0 - r), y, w * r, h), col)
	var label := "RAGE MAX!" if full else "POW"
	var lx := x0 if i == 0 else x0 + w - 200.0
	var al := HORIZONTAL_ALIGNMENT_LEFT if i == 0 else HORIZONTAL_ALIGNMENT_RIGHT
	_text(font, Vector2(lx, y - 8), label, 26 if full else 20, Color(1, 0.9, 0.5) if full else Color(1, 1, 1, 0.85), al, 200.0, 6)
	if full:
		var hint := "SUPER READY"
		_text(font, Vector2(x0 if i == 0 else x0 + w - 200.0, y - 34), hint, 18, Color(1, 1, 1, 0.6 + 0.4 * sin(t * 8.0)), al, 200.0, 5)


func _draw_banner(font: Font, b: Dictionary) -> void:
	var u: float = float(b.t) / b.dur
	var sc := 1.0
	if b.t < 8:
		sc = lerpf(2.2, 1.0, b.t / 8.0)
	var a := 1.0
	if b.dur - b.t < 10:
		a = (b.dur - b.t) / 10.0
	var cy := 330.0
	# brush stroke band
	var bw := 1280.0 * minf(1.0, b.t / 6.0)
	var band := PackedVector2Array([Vector2(640 - bw * 0.5, cy - 70), Vector2(640 + bw * 0.5 + 40, cy - 80), Vector2(640 + bw * 0.5, cy + 40), Vector2(640 - bw * 0.5 - 40, cy + 30)])
	draw_colored_polygon(band, Color(0.6, 0.05, 0.05, 0.75 * a))
	var size := int(b.size * sc)
	var c: Color = b.col
	c.a = a
	draw_set_transform(Vector2(0, 0), 0.0, Vector2.ONE)
	_text(font, Vector2(0, cy + size * 0.32), b.text, size, c, HORIZONTAL_ALIGNMENT_CENTER, 1280.0, 14)
	if b.sub != "":
		_text(font, Vector2(0, cy + 80), b.sub, 34, Color(1, 1, 1, a), HORIZONTAL_ALIGNMENT_CENTER, 1280.0, 8)
	var _unused := u


func _draw_callout(font: Font, c: Dictionary) -> void:
	var a := 1.0
	if c.dur - c.t < 12:
		a = (c.dur - c.t) / 12.0
	var slide := maxf(0.0, 1.0 - c.t / 8.0) * 200.0
	var y := 150.0
	if c.p == 1:
		var x := 40.0 - slide
		draw_colored_polygon(PackedVector2Array([Vector2(x - 40, y - 42), Vector2(x + 560, y - 42), Vector2(x + 520, y + 14), Vector2(x - 40, y + 14)]), Color(0, 0, 0, 0.45 * a))
		_text(font, Vector2(x, y), c.text, 40, Color(1, 0.85, 0.25, a), HORIZONTAL_ALIGNMENT_LEFT, -1, 8)
	else:
		var x := 1240.0 + slide
		draw_colored_polygon(PackedVector2Array([Vector2(x - 560, y - 42), Vector2(x + 40, y - 42), Vector2(x + 40, y + 14), Vector2(x - 520, y + 14)]), Color(0, 0, 0, 0.45 * a))
		_text(font, Vector2(x - 700, y), c.text, 40, Color(1, 0.85, 0.25, a), HORIZONTAL_ALIGNMENT_RIGHT, 700.0, 8)


func _draw_cutin(font: Font) -> void:
	var u: float = float(cutin.t) / cutin.dur
	var a := 1.0 if u < 0.85 else (1.0 - u) / 0.15
	var f = cutin.f
	var side: int = 1 if f.player == 1 else -1
	var cy := 400.0
	var band := PackedVector2Array([Vector2(0, cy - 150), Vector2(1280, cy - 210), Vector2(1280, cy + 40), Vector2(0, cy + 100)])
	var acc: Color = f.cd.accent
	draw_colored_polygon(band, Color(acc.r * 0.6, acc.g * 0.6, acc.b * 0.6, 0.85 * a))
	for k in 14:
		var yy := cy - 150 + k * 18.0 + fmod(t * 600.0, 18.0)
		draw_line(Vector2(0, yy), Vector2(1280, yy - 60), Color(1, 1, 1, 0.08 * a), 2.0)
	var tx := 560.0 if side == 1 else 80.0
	var slide := (1.0 - minf(1.0, u * 5.0)) * 300.0 * side
	_text(font, Vector2(tx + slide, cy - 20), f.cd.display_name, 46, Color(1, 1, 1, a), HORIZONTAL_ALIGNMENT_LEFT, 650.0, 10)
	_text(font, Vector2(tx + slide, cy + 40), cutin.title, 50, Color(1, 0.85, 0.25, a), HORIZONTAL_ALIGNMENT_LEFT, 650.0, 10)
