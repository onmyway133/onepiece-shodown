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
var portraits: Array = []
const PORTRAIT := Vector2(104, 104)


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
	for i in 2:
		var f = a if i == 0 else b
		var clip := Control.new()
		clip.clip_contents = true
		clip.mouse_filter = Control.MOUSE_FILTER_IGNORE
		clip.position = Vector2(22.0 if i == 0 else 1280.0 - 22.0 - PORTRAIT.x, 14)
		clip.size = PORTRAIT
		add_child(clip)
		move_child(clip, 0)
		var r := Rig.new()
		r.cd = f.cd
		var sc := 1.5
		r.scale = Vector2(sc if i == 0 else -sc, sc)
		clip.add_child(r)
		portraits.append({"clip": clip, "rig": r, "f": f})
		_update_portrait(portraits[i])
	# the HUD draws behind its children, so a top layer draws the portrait borders
	var top := Control.new()
	top.mouse_filter = Control.MOUSE_FILTER_IGNORE
	top.size = size
	top.draw.connect(func(): _draw_on_top(top))
	add_child(top)
	_top = top


var _top: Control


func _draw_on_top(cv: Control) -> void:
	for i in 2:
		var x := 22.0 if i == 0 else 1280.0 - 22.0 - PORTRAIT.x
		cv.draw_rect(Rect2(Vector2(x, 14), PORTRAIT), GOLD, false, 3.0)


func _update_portrait(pt: Dictionary) -> void:
	var f = pt.f
	var p: Dictionary = f.cd.pose("idle").duplicate()
	p.t = 0.0
	p.head = -4.0
	if f.state in ["hit", "air_hit", "down", "ko_down"] or f.ko:
		p.face = "hurt"
	elif f.state == "attack":
		p.face = "attack"
	elif f.rage_mode > 0:
		p.face = "angry"
	elif f.state == "win":
		p.face = "grin"
	var r = pt.rig
	r.st = {"time": t, "tint": f.cd.tint_for(f.pose), "flash": f.flash}
	r.set_pose(p, true)
	var R: float = f.cd.dims.head
	var head: Vector2 = r.J.head * r.scale.y
	var cx: float = PORTRAIT.x * 0.5 - head.x * signf(r.scale.x) * 1.0
	r.position = Vector2(PORTRAIT.x * 0.5 - head.x * signf(r.scale.x) - R * 0.3 * r.scale.x, PORTRAIT.y * 0.62 - head.y)
	var _u := cx


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


func _physics_process(delta: float) -> void:
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
	for pt in portraits:
		_update_portrait(pt)
	queue_redraw()
	if _top:
		_top.queue_redraw()


func _draw() -> void:
	var font := Game.font("display")
	if dark > 0.0:
		draw_rect(Rect2(0, 0, 1280, 720), Color(0.05, 0.0, 0.08, dark))
	if not cutin.is_empty():
		_draw_cutin(font)
	if f1 == null:
		return
	_draw_portrait_frames()
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


const GOLD := Color(0.98, 0.78, 0.25)
const INK := Color(0.04, 0.02, 0.04)
const SPIRIT := Color(0.62, 0.3, 0.95)


## A rough ink brush stroke from x0 to x1, tapering into bristles at one end.
func _brush(x0: float, y0: float, x1: float, y1: float, seed: int, c: Color, taper_right := true) -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed
	var top := PackedVector2Array()
	var bot := PackedVector2Array()
	var n := int(absf(x1 - x0) / 14.0) + 2
	var h := y1 - y0
	for i in n + 1:
		var u := float(i) / n
		var x := lerpf(x0, x1, u)
		var tp := u if taper_right else 1.0 - u
		var squeeze := clampf((tp - 0.82) / 0.18, 0.0, 1.0)
		var j := rng.randf_range(-2.5, 2.5)
		top.append(Vector2(x, y0 + j + h * 0.3 * squeeze))
		bot.append(Vector2(x, y1 + rng.randf_range(-2.5, 2.5) - h * 0.45 * squeeze))
	# splayed bristles at the dry end
	var end_x := x1 if taper_right else x0
	var sgn := 1.0 if taper_right else -1.0
	var tip := PackedVector2Array()
	for k in 5:
		var yy := lerpf(y0 + h * 0.3, y1 - h * 0.3, float(k) / 4.0)
		tip.append(Vector2(end_x + sgn * rng.randf_range(18.0, 46.0), yy))
		tip.append(Vector2(end_x + sgn * 4.0, yy + h * 0.06))
	if not taper_right:
		tip.reverse()
	bot.reverse()
	var poly := top
	if taper_right:
		poly = top + tip + bot
	else:
		poly = top + bot + tip
	if not Geometry2D.triangulate_polygon(poly).is_empty():
		draw_colored_polygon(poly, c)
	# dry brush streaks
	for k in 4:
		var yy := y0 + h * rng.randf_range(0.2, 0.8)
		var xa := lerpf(x0, x1, rng.randf_range(0.0, 0.5))
		var xb := lerpf(x0, x1, rng.randf_range(0.6, 1.0))
		draw_line(Vector2(xa, yy), Vector2(xb, yy + rng.randf_range(-2, 2)), Color(c.r + 0.08, c.g + 0.06, c.b + 0.06, c.a * 0.6), 1.5, true)


func _draw_bar(font: Font, f, i: int) -> void:
	var w := 470.0
	var h := 24.0
	var y := 36.0
	var x0 := 140.0 if i == 0 else 1280.0 - 140.0 - w
	# ink backing
	if i == 0:
		_brush(110.0, y - 16, x0 + w + 6, y + h + 14, 11, Color(INK, 0.92), true)
	else:
		_brush(x0 - 6, y - 16, 1170.0, y + h + 14, 23, Color(INK, 0.92), false)
	draw_rect(Rect2(x0, y, w, h), Color(0.22, 0.04, 0.05))
	var ratio_lag: float = lag[i]
	var ratio: float = shown[i]
	_fill(x0, y, w, h, ratio_lag, i, Color(1.0, 0.95, 0.9) if f.flash > 0.0 else Color(0.85, 0.12, 0.1))
	var c1 := Color(1.0, 0.93, 0.55)
	var c2 := GOLD
	var c3 := Color(0.85, 0.5, 0.12)
	if ratio < 0.3:
		var pulse := 0.5 + 0.5 * sin(t * 10.0)
		c2 = c2.lerp(Color(1, 0.3, 0.2), pulse)
		c3 = c3.lerp(Color(0.8, 0.1, 0.1), pulse)
	_fill(x0, y, w, h * 0.35, ratio, i, c1)
	_fill(x0, y + h * 0.35, w, h * 0.35, ratio, i, c2)
	_fill(x0, y + h * 0.7, w, h * 0.3, ratio, i, c3)
	draw_rect(Rect2(x0, y, w, h), Color(0.1, 0.06, 0.04), false, 2.0)
	# name
	var nx := x0 + 10.0 if i == 0 else x0 + w - 310.0
	var al := HORIZONTAL_ALIGNMENT_LEFT if i == 0 else HORIZONTAL_ALIGNMENT_RIGHT
	_text(font, Vector2(nx, y + h + 30), f.cd.display_name, 28, Color(1, 1, 1), al, 300.0, 7)
	# round wins: spirit gems
	for k in Game.rounds_to_win:
		var cx := x0 + w - 74.0 - k * 32.0 if i == 0 else x0 + 74.0 + k * 32.0
		var cy := y + h + 26.0
		var won: bool = k < f.wins
		var gem := PackedVector2Array([Vector2(cx, cy - 13), Vector2(cx + 11, cy), Vector2(cx, cy + 13), Vector2(cx - 11, cy)])
		draw_colored_polygon(gem, INK)
		var inner := PackedVector2Array([Vector2(cx, cy - 8), Vector2(cx + 7, cy), Vector2(cx, cy + 8), Vector2(cx - 7, cy)])
		draw_colored_polygon(inner, SPIRIT.lightened(0.15) if won else Color(0.25, 0.2, 0.3))
		if won:
			draw_circle(Vector2(cx - 2, cy - 3), 2.0, Color(1, 1, 1, 0.8))
		draw_polyline(gem + PackedVector2Array([gem[0]]), GOLD, 1.6, true)


func _fill(x0: float, y: float, w: float, h: float, ratio: float, i: int, c: Color) -> void:
	if ratio <= 0.001:
		return
	var fw := w * ratio
	if i == 0:
		# P1 drains toward the left: anchored at the center edge
		draw_rect(Rect2(x0 + w - fw, y, fw, h), c)
	else:
		draw_rect(Rect2(x0, y, fw, h), c)


func _draw_portrait_frames() -> void:
	for i in 2:
		var x := 22.0 if i == 0 else 1280.0 - 22.0 - PORTRAIT.x
		var r := Rect2(Vector2(x, 14), PORTRAIT)
		_brush(r.position.x - 12, r.position.y - 6, r.end.x + 12, r.end.y + 8, 40 + i, Color(INK, 0.95), i == 1)
		var f = f1 if i == 0 else f2
		draw_rect(r, f.cd.accent.darkened(0.55))
		draw_rect(r.grow(-4), f.cd.accent.darkened(0.25))


func _draw_timer(font: Font) -> void:
	var c := Vector2(640, 58)
	_brush(560, 16, 720, 100, 77, Color(INK, 0.55), true)
	var s := "%02d" % fight.time_left
	if Game.mode == "training":
		s = "∞"
	var col := Color(1, 1, 1)
	if fight.time_left <= 10 and Game.mode != "training":
		col = Color(1, 0.4, 0.3).lerp(Color(1, 1, 1), 0.5 + 0.5 * sin(t * 12.0))
	_text(font, c + Vector2(-90, 30), s, 84, col, HORIZONTAL_ALIGNMENT_CENTER, 180.0, 12)
	_text(font, c + Vector2(-40, 76), "VS", 26, Color(1, 1, 1, 0.25), HORIZONTAL_ALIGNMENT_CENTER, 80.0, 4)


## The Grand Strike gauge: five segments of POW; full means RAGE MAX and super ready.
func _draw_rage(font: Font, f, i: int) -> void:
	var w := 330.0
	var h := 18.0
	var y := 672.0
	var x0 := 60.0 if i == 0 else 1280.0 - 60.0 - w
	if i == 0:
		_brush(x0 - 30, y - 12, x0 + w + 10, y + h + 10, 91, Color(INK, 0.85), true)
	else:
		_brush(x0 - 10, y - 12, x0 + w + 30, y + h + 10, 92, Color(INK, 0.85), false)
	var r: float = f.rage / 100.0
	var full: bool = f.rage_mode > 0
	var segs := 5
	var gap := 5.0
	var sw := (w - gap * (segs - 1)) / segs
	for k in segs:
		var kk := k if i == 0 else segs - 1 - k
		var sx := x0 + kk * (sw + gap)
		draw_rect(Rect2(sx, y, sw, h), Color(0.16, 0.1, 0.16))
		var amt := clampf(r * segs - k, 0.0, 1.0)
		if amt <= 0.0:
			continue
		var col := SPIRIT if amt < 1.0 else GOLD
		if full:
			col = Color(1, 0.25, 0.1).lerp(Color(1, 0.9, 0.35), 0.5 + 0.5 * sin(t * 14.0 + k))
		var fw := sw * amt
		if i == 0:
			draw_rect(Rect2(sx, y, fw, h), col)
		else:
			draw_rect(Rect2(sx + sw - fw, y, fw, h), col)
		draw_rect(Rect2(sx, y, sw, h * 0.35), Color(1, 1, 1, 0.18))
	var label := "RAGE MAX!" if full else "GRAND STRIKE"
	var lx := x0 if i == 0 else x0 + w - 300.0
	var al := HORIZONTAL_ALIGNMENT_LEFT if i == 0 else HORIZONTAL_ALIGNMENT_RIGHT
	_text(font, Vector2(lx, y - 10), label, 26 if full else 20, Color(1, 0.9, 0.5) if full else Color(1, 1, 1, 0.9), al, 300.0, 6)
	if full:
		_text(font, Vector2(x0 if i == 0 else x0 + w - 300.0, y - 38), "SUPER READY", 18, Color(1, 1, 1, 0.6 + 0.4 * sin(t * 8.0)), al, 300.0, 5)


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
