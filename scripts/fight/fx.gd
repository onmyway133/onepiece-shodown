extends Node2D
## Particle and impact effects drawn in world space, plus weapon trails.
## Two layers: normal (smoke, dust, ink, trails) and additive (sparks, fire, glows).

var fighters: Array = []
var _norm := Node2D.new()
var _add := Node2D.new()
var parts_n: Array = []
var parts_a: Array = []

## Soft radial glow and smoke puff textures, built once.
static var GLOW: Texture2D
static var PUFF: Texture2D


static func _radial(stops: Array, size := 128) -> Texture2D:
	var g := Gradient.new()
	g.offsets = PackedFloat32Array(stops.map(func(s): return s[0]))
	g.colors = PackedColorArray(stops.map(func(s): return s[1]))
	var t := GradientTexture2D.new()
	t.gradient = g
	t.fill = GradientTexture2D.FILL_RADIAL
	t.fill_from = Vector2(0.5, 0.5)
	t.fill_to = Vector2(1.0, 0.5)
	t.width = size
	t.height = size
	return t


static func textures() -> void:
	if GLOW == null:
		GLOW = _radial([[0.0, Color(1, 1, 1, 1)], [0.25, Color(1, 1, 1, 0.75)], [0.6, Color(1, 1, 1, 0.18)], [1.0, Color(1, 1, 1, 0)]])
		PUFF = _radial([[0.0, Color(1, 1, 1, 0.9)], [0.55, Color(1, 1, 1, 0.6)], [0.85, Color(1, 1, 1, 0.15)], [1.0, Color(1, 1, 1, 0)]])


static func glow(cv: CanvasItem, pos: Vector2, r: float, c: Color) -> void:
	cv.draw_texture_rect(GLOW, Rect2(pos - Vector2(r, r), Vector2(r, r) * 2.0), false, c)


func _ready() -> void:
	textures()
	add_child(_norm)
	add_child(_add)
	var mat := CanvasItemMaterial.new()
	mat.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
	_add.material = mat
	_norm.draw.connect(_draw_norm)
	_add.draw.connect(_draw_add)


func clear() -> void:
	parts_n.clear()
	parts_a.clear()


func _p(list: Array, d: Dictionary) -> void:
	d.t = 0
	if not d.has("vel"):
		d.vel = Vector2.ZERO
	if list.size() < 1200:
		list.append(d)


# ---------------------------------------------------------------- emitters

func spark(pos: Vector2, kind: String, facing: int) -> void:
	var dirx := float(facing)
	match kind:
		"block":
			_p(parts_a, {"k": "glow", "pos": pos, "r": 70.0, "life": 10, "col": Color(0.35, 0.6, 1.0, 0.9)})
			_p(parts_a, {"k": "ring", "pos": pos, "r0": 10.0, "r1": 60.0, "life": 12, "col": Color(0.5, 0.8, 1.0), "w": 5.0})
			for i in 9:
				var a := randf_range(-1.2, 1.2) + (PI if dirx > 0 else 0.0)
				_p(parts_a, {"k": "line", "pos": pos, "vel": Vector2(cos(a), sin(a)) * randf_range(6, 13), "life": 11, "len": 24.0, "w": 3.0, "col": Color(0.7, 0.9, 1.0), "drag": 0.85})
		"slash":
			var ang := randf_range(-0.5, 0.5) + (0.0 if randf() < 0.5 else PI / 2.0)
			arc_slash(pos, ang, 150.0, Color(1.0, 0.3, 0.2), dirx)
			_p(parts_a, {"k": "glow", "pos": pos, "r": 150.0, "life": 12, "col": Color(1.0, 0.45, 0.3, 0.8)})
			_p(parts_a, {"k": "star", "pos": pos, "r": 80.0, "life": 9, "col": Color(1, 0.9, 0.7)})
			_blood(pos, dirx, 10)
			for i in 14:
				var a := randf() * TAU
				_p(parts_a, {"k": "line", "pos": pos, "vel": Vector2(cos(a), sin(a)) * randf_range(8, 22), "life": randi_range(10, 18), "len": 34.0, "w": 3.0, "col": Color(1.0, 0.8, 0.5), "drag": 0.86})
		"fire":
			_p(parts_a, {"k": "glow", "pos": pos, "r": 170.0, "life": 14, "col": Color(1.0, 0.45, 0.1, 0.9)})
			_p(parts_a, {"k": "star", "pos": pos, "r": 85.0, "life": 9, "col": Color(1, 0.6, 0.2)})
			for i in 22:
				var a := randf() * TAU
				_p(parts_a, {"k": "flame", "pos": pos + Vector2(cos(a), sin(a)) * 10.0, "vel": Vector2(cos(a), sin(a)) * randf_range(3, 10), "life": randi_range(16, 32), "r": randf_range(12, 26), "drag": 0.9, "rise": 0.15})
			for i in 8:
				_p(parts_a, {"k": "ember", "pos": pos, "vel": Vector2(randf_range(-8, 8), randf_range(-12, -2)), "life": randi_range(24, 44), "r": 3.0, "drag": 0.96, "rise": -0.25})
		"electric":
			_p(parts_a, {"k": "glow", "pos": pos, "r": 150.0, "life": 12, "col": Color(1.0, 0.95, 0.45, 0.9)})
			_p(parts_a, {"k": "star", "pos": pos, "r": 90.0, "life": 9, "col": Color(1, 1, 0.8)})
			for i in 6:
				_p(parts_a, {"k": "zap", "pos": pos, "life": randi_range(5, 10), "r": randf_range(40, 80), "seed": randi(), "col": Color(1.0, 0.95, 0.5)})
		"water":
			_p(parts_a, {"k": "glow", "pos": pos, "r": 130.0, "life": 12, "col": Color(0.4, 0.7, 1.0, 0.8)})
			_p(parts_a, {"k": "star", "pos": pos, "r": 80.0, "life": 9, "col": Color(0.85, 0.95, 1.0)})
			for i in 14:
				var a := randf() * TAU
				_p(parts_n, {"k": "drop", "pos": pos, "vel": Vector2(cos(a) * randf_range(4, 12), sin(a) * randf_range(3, 9) - 3.0), "life": randi_range(14, 26), "r": randf_range(3.0, 6.0), "drag": 0.96, "rise": -0.45, "col": Color(0.6, 0.85, 1.0, 0.9)})
		"heavy":
			_p(parts_a, {"k": "glow", "pos": pos, "r": 160.0, "life": 12, "col": Color(1.0, 0.85, 0.5, 0.9)})
			_p(parts_a, {"k": "star", "pos": pos, "r": 105.0, "life": 10, "col": Color(1, 0.95, 0.75)})
			_p(parts_a, {"k": "ring", "pos": pos, "r0": 20.0, "r1": 130.0, "life": 14, "col": Color(1, 0.85, 0.5), "w": 7.0})
			impact_lines(pos, 12, 220.0)
			for i in 20:
				var a := randf() * TAU
				_p(parts_a, {"k": "line", "pos": pos, "vel": Vector2(cos(a), sin(a)) * randf_range(10, 26), "life": randi_range(10, 20), "len": 42.0, "w": 4.0, "col": Color(1.0, 0.85, 0.4), "drag": 0.85})
		_:
			_p(parts_a, {"k": "glow", "pos": pos, "r": 95.0, "life": 9, "col": Color(1.0, 0.9, 0.6, 0.8)})
			_p(parts_a, {"k": "star", "pos": pos, "r": 60.0, "life": 7, "col": Color(1, 0.95, 0.8)})
			for i in 10:
				var a := randf() * TAU
				_p(parts_a, {"k": "line", "pos": pos, "vel": Vector2(cos(a), sin(a)) * randf_range(7, 16), "life": randi_range(8, 13), "len": 26.0, "w": 3.0, "col": Color(1.0, 0.9, 0.5), "drag": 0.85})


## Samurai Shodown style crescent: an ink stroke with a hot colored edge.
func arc_slash(pos: Vector2, ang: float, r: float, c: Color, dirx := 1.0) -> void:
	_p(parts_n, {"k": "arc", "pos": pos, "ang": ang, "r": r, "life": 14, "col": Color(0.05, 0.02, 0.04), "dir": dirx, "w": 30.0})
	_p(parts_a, {"k": "arc", "pos": pos, "ang": ang, "r": r * 0.97, "life": 14, "col": c, "dir": dirx, "w": 18.0})
	_p(parts_a, {"k": "arc", "pos": pos, "ang": ang, "r": r * 0.95, "life": 10, "col": Color(1, 1, 0.95), "dir": dirx, "w": 7.0})


## Manga impact lines: black wedges pointing at the hit.
func impact_lines(pos: Vector2, n: int, r: float) -> void:
	for i in n:
		var a := TAU * (float(i) + randf_range(-0.3, 0.3)) / n
		_p(parts_n, {"k": "wedge", "pos": pos, "ang": a, "r0": r * randf_range(0.45, 0.6), "r1": r * randf_range(1.1, 1.5), "w": randf_range(4.0, 9.0), "life": 7, "col": Color(0.05, 0.02, 0.05, 0.85)})


func _blood(pos: Vector2, dirx: float, n: int) -> void:
	for i in n:
		var v := Vector2(dirx * randf_range(2, 11), randf_range(-9, -1))
		_p(parts_n, {"k": "drop", "pos": pos, "vel": v, "life": randi_range(18, 30), "r": randf_range(2.5, 5.5), "drag": 0.97, "rise": -0.45, "col": Color(0.75, 0.05, 0.08, 0.95)})


func dust(pos: Vector2, dirx: int) -> void:
	for i in 10:
		var v := Vector2(randf_range(-3, 3) + dirx * 3.0, randf_range(-2.5, -0.5))
		_p(parts_n, {"k": "smoke", "pos": pos + Vector2(randf_range(-30, 30), -6), "vel": v, "life": randi_range(24, 40), "r": randf_range(14, 26), "grow": 0.8, "col": Color(0.85, 0.78, 0.66, 0.5), "drag": 0.92})


func smoke(pos: Vector2, c: Color, scale := 1.0) -> void:
	_p(parts_n, {"k": "smoke", "pos": pos, "vel": Vector2(randf_range(-0.6, 0.6), randf_range(-2.4, -1.2)), "life": randi_range(26, 40), "r": 11.0 * scale, "grow": 0.6 * scale, "col": c, "drag": 0.97})


func flame(pos: Vector2, vel: Vector2, r := 14.0, life := 22) -> void:
	_p(parts_a, {"k": "flame", "pos": pos, "vel": vel, "life": life, "r": r, "drag": 0.94, "rise": 0.12})


func ring(pos: Vector2, c: Color, r1 := 120.0, life := 16, w := 6.0) -> void:
	_p(parts_a, {"k": "ring", "pos": pos, "r0": 10.0, "r1": r1, "life": life, "col": c, "w": w})
	_p(parts_a, {"k": "glow", "pos": pos, "r": r1 * 0.8, "life": life, "col": Color(c.r, c.g, c.b, 0.5)})


## Flat ellipse ring along the ground plane (shockwaves).
func ering(pos: Vector2, c: Color, r1 := 160.0, life := 16, w := 6.0) -> void:
	_p(parts_a, {"k": "ering", "pos": pos, "r0": 10.0, "r1": r1, "life": life, "col": c, "w": w})


## A lightning bolt striking down onto pos from the sky.
func lightning(pos: Vector2) -> void:
	_p(parts_a, {"k": "bolt", "pos": pos, "life": 16, "seed": randi(), "col": Color(1.0, 0.95, 0.55)})
	_p(parts_a, {"k": "glow", "pos": pos, "r": 220.0, "life": 14, "col": Color(1.0, 0.9, 0.4, 0.9)})
	ering(Vector2(pos.x, 0.0), Color(1.0, 0.95, 0.6), 180.0, 16, 7.0)
	for i in 8:
		_p(parts_a, {"k": "zap", "pos": pos + Vector2(randf_range(-30, 30), randf_range(-150, 100)), "life": randi_range(6, 12), "r": randf_range(40, 80), "seed": randi(), "col": Color(1.0, 0.95, 0.6)})


## Radial anime speed lines around a point (supers, KO).
func speed_lines(pos: Vector2, life := 30, c := Color(1, 1, 1, 0.7)) -> void:
	_p(parts_a, {"k": "speed", "pos": pos, "life": life, "col": c, "seed": randi()})


func burst(name: String, pos: Vector2, facing: int) -> void:
	match name:
		"fire_burst":
			_p(parts_a, {"k": "glow", "pos": pos, "r": 260.0, "life": 20, "col": Color(1.0, 0.4, 0.05, 0.9)})
			for i in 36:
				var a := randf() * TAU
				flame(pos + Vector2(cos(a), sin(a)) * 20.0, Vector2(cos(a), sin(a)) * randf_range(3, 11), randf_range(16, 34), randi_range(20, 42))
			ring(pos, Color(1, 0.5, 0.1), 190.0, 18, 10.0)
		"fire_trail":
			for i in 4:
				flame(pos + Vector2(randf_range(-20, 20), randf_range(-20, 20)), Vector2(-facing * randf_range(1, 3), randf_range(-2, 0)), randf_range(12, 22))
		"shock":
			ring(pos, Color(1, 1, 1), 170.0, 14, 8.0)
			ring(pos, Color(0.5, 0.8, 1), 110.0, 18, 5.0)
			impact_lines(pos, 14, 260.0)
		"dark_ring":
			ring(pos, Color(0.7, 0.3, 1.0), 210.0, 22, 8.0)
			speed_lines(pos, 26, Color(0.75, 0.5, 1.0, 0.6))
		"tornado":
			for i in 26:
				var a := randf() * TAU
				_p(parts_a, {"k": "line", "pos": pos + Vector2(randf_range(-60, 60), randf_range(-120, 40)), "vel": Vector2(cos(a) * 14.0, -randf_range(4, 10)), "life": randi_range(10, 22), "len": 44.0, "w": 3.0, "col": Color(0.7, 1.0, 0.85), "drag": 0.9})
			_p(parts_a, {"k": "glow", "pos": pos + Vector2(0, -60), "r": 160.0, "life": 16, "col": Color(0.4, 1.0, 0.8, 0.5)})
		"smoke_puff":
			for i in 12:
				smoke(pos + Vector2(randf_range(-30, 30), randf_range(-20, 20)), Color(0.92, 0.92, 0.96, 0.6), 2.0)
		"dust":
			dust(pos, facing)
		"slash_x":
			arc_slash(pos, -0.7, 170.0, Color(0.4, 0.8, 1.0), facing)
			arc_slash(pos, 0.7, 170.0, Color(0.4, 0.8, 1.0), -facing)
		"slash_dark":
			arc_slash(pos, -0.5, 230.0, Color(0.3, 1.0, 0.55), facing)
			arc_slash(pos, 0.6, 200.0, Color(0.3, 1.0, 0.55), -facing)
			impact_lines(pos, 14, 300.0)
		"lightning":
			lightning(pos)
		"room":
			_p(parts_n, {"k": "dome", "pos": pos, "r": 330.0, "life": 70, "col": Color(0.55, 0.85, 1.0)})
		"room_swap":
			_p(parts_a, {"k": "glow", "pos": pos, "r": 120.0, "life": 12, "col": Color(0.5, 0.85, 1.0, 0.9)})
			for i in 6:
				var a := randf() * TAU
				_p(parts_a, {"k": "cube", "pos": pos + Vector2(cos(a), sin(a)) * 30.0, "vel": Vector2(cos(a), sin(a)) * randf_range(2, 6), "life": 16, "r": randf_range(8, 16), "col": Color(0.6, 0.9, 1.0), "drag": 0.9, "rot": randf() * TAU})
		"water":
			_p(parts_a, {"k": "glow", "pos": pos, "r": 150.0, "life": 14, "col": Color(0.3, 0.6, 1.0, 0.7)})
			ering(pos, Color(0.6, 0.85, 1.0), 160.0, 18, 6.0)
			for i in 16:
				var a := randf() * TAU
				_p(parts_n, {"k": "drop", "pos": pos, "vel": Vector2(cos(a) * randf_range(3, 11), sin(a) * randf_range(3, 8) - 4.0), "life": randi_range(18, 30), "r": randf_range(3.0, 6.0), "drag": 0.97, "rise": -0.4, "col": Color(0.55, 0.8, 1.0, 0.9)})
		"shockwave":
			ering(pos, Color(1, 1, 1), 220.0, 16, 9.0)
			ering(pos, Color(0.6, 0.85, 1.0), 150.0, 20, 6.0)
			_p(parts_a, {"k": "glow", "pos": pos, "r": 160.0, "life": 12, "col": Color(0.7, 0.9, 1.0, 0.8)})
			impact_lines(pos, 16, 280.0)
		"electric":
			_p(parts_a, {"k": "glow", "pos": pos, "r": 140.0, "life": 12, "col": Color(1.0, 0.95, 0.4, 0.85)})
			for i in 8:
				_p(parts_a, {"k": "zap", "pos": pos, "life": randi_range(6, 12), "r": randf_range(40, 90), "seed": randi(), "col": Color(1.0, 0.95, 0.5)})
		"electric_small":
			_p(parts_a, {"k": "zap", "pos": pos, "life": 5, "r": randf_range(30, 50), "seed": randi(), "col": Color(1.0, 0.95, 0.5)})
		"parry":
			_p(parts_a, {"k": "glow", "pos": pos, "r": 140.0, "life": 12, "col": Color(1, 1, 1, 0.9)})
			_p(parts_a, {"k": "star", "pos": pos, "r": 120.0, "life": 10, "col": Color(1, 1, 0.9)})
			ring(pos, Color(1, 0.95, 0.7), 150.0, 14, 7.0)
		_:
			spark(pos, "heavy", facing)


# ---------------------------------------------------------------- update

func _physics_process(_d: float) -> void:
	_step(parts_n)
	_step(parts_a)
	_norm.queue_redraw()
	_add.queue_redraw()


func _step(list: Array) -> void:
	var i := 0
	while i < list.size():
		var p: Dictionary = list[i]
		p.t += 1
		if p.t >= p.life:
			list.remove_at(i)
			continue
		p.pos += p.vel
		p.vel *= p.get("drag", 1.0)
		if p.has("rise"):
			p.vel.y -= p.rise
		i += 1


func _draw_norm() -> void:
	for f in fighters:
		_draw_trail(_norm, f, false)
	_draw_list(_norm, parts_n)


func _draw_add() -> void:
	for f in fighters:
		_draw_trail(_add, f, true)
	_draw_list(_add, parts_a)


## Catmull-Rom smoothing of the sampled trail points.
static func _smooth(pts: Array) -> Array:
	if pts.size() < 3:
		return pts
	var out := []
	for i in pts.size() - 1:
		var p0: Vector2 = pts[maxi(i - 1, 0)]
		var p1: Vector2 = pts[i]
		var p2: Vector2 = pts[i + 1]
		var p3: Vector2 = pts[mini(i + 2, pts.size() - 1)]
		for k in 3:
			var t := float(k) / 3.0
			var t2 := t * t
			var t3 := t2 * t
			out.append(0.5 * ((2.0 * p1) + (-p0 + p2) * t + (2.0 * p0 - 5.0 * p1 + 4.0 * p2 - p3) * t2 + (-p0 + 3.0 * p1 - 3.0 * p2 + p3) * t3))
	out.append(pts[pts.size() - 1])
	return out


func _draw_trail(cv: CanvasItem, f, additive: bool) -> void:
	var tr: Array = f.trail
	if tr.size() < 2:
		return
	var base := _smooth(tr.map(func(s): return s[0]))
	var tip := _smooth(tr.map(func(s): return s[1]))
	var n := tip.size()
	var c: Color = f.cd.trail_color
	for i in range(1, n):
		var u := float(i) / (n - 1)
		var q: PackedVector2Array
		if additive:
			# hot edge along the tip path
			var b0: Vector2 = tip[i - 1].lerp(base[i - 1], 0.35)
			var b1: Vector2 = tip[i].lerp(base[i], 0.35)
			q = PackedVector2Array([tip[i - 1], tip[i], b1, b0])
			if _valid_quad(q):
				cv.draw_colored_polygon(q, Color(c.r, c.g, c.b, u * 0.7))
		else:
			q = PackedVector2Array([tip[i - 1], tip[i], base[i], base[i - 1]])
			if _valid_quad(q):
				cv.draw_colored_polygon(q, Color(c.r, c.g, c.b, u * u * 0.5))
	if additive:
		var edge := PackedVector2Array()
		for p in tip:
			edge.append(p)
		cv.draw_polyline(edge, Color(1, 1, 1, 0.8), 3.0, true)


func _valid_quad(q: PackedVector2Array) -> bool:
	var area := 0.0
	for i in 4:
		area += q[i].cross(q[(i + 1) % 4])
	return absf(area) > 4.0 and Geometry2D.triangulate_polygon(q).size() > 0


func _draw_list(cv: CanvasItem, list: Array) -> void:
	for p in list:
		var u := float(p.t) / float(p.life)
		match String(p.k):
			"line":
				var d: Vector2 = p.vel.normalized() * p.len * (1.0 - u)
				var c: Color = p.col
				c.a = 1.0 - u
				cv.draw_line(p.pos - d, p.pos, c, p.w, true)
			"ring":
				var c: Color = p.col
				c.a = 1.0 - u
				cv.draw_arc(p.pos, lerpf(p.r0, p.r1, sqrt(u)), 0.0, TAU, 40, c, p.w * (1.0 - u * 0.6), true)
			"glow":
				var c: Color = p.col
				c.a *= (1.0 - u) * (1.0 - u)
				glow(cv, p.pos, p.r * (0.7 + u * 0.5), c)
			"star":
				var c: Color = p.col
				c.a = 1.0 - u
				var r: float = p.r * (1.0 - u * 0.5)
				var pts := PackedVector2Array()
				for k in 16:
					var a: float = TAU * k / 16.0 + p.t * 0.05
					var rr := r if k % 2 == 0 else r * 0.26
					pts.append(p.pos + Vector2(cos(a), sin(a)) * rr)
				cv.draw_colored_polygon(pts, c)
				glow(cv, p.pos, r * 0.6, Color(1, 1, 1, 1.0 - u))
			"arc":
				_draw_arc_slash(cv, p, u)
			"wedge":
				var d := Vector2(cos(p.ang), sin(p.ang))
				var nrm: Vector2 = Vector2(-d.y, d.x) * float(p.w) * (1.0 - u * 0.5)
				var a: Vector2 = p.pos + d * p.r0
				var b: Vector2 = p.pos + d * p.r1
				var c: Color = p.col
				c.a *= 1.0 - u
				cv.draw_colored_polygon(PackedVector2Array([a, b + nrm, b - nrm]), c)
			"speed":
				_draw_speed(cv, p, u)
			"ering":
				var c: Color = p.col
				c.a = 1.0 - u
				var rr := lerpf(p.r0, p.r1, sqrt(u))
				var pts := CharData.ellipse(p.pos, rr, rr * 0.22, 32)
				pts.append(pts[0])
				cv.draw_polyline(pts, c, p.w * (1.0 - u * 0.6), true)
			"bolt":
				_draw_bolt(cv, p, u)
			"zap":
				var rng := RandomNumberGenerator.new()
				rng.seed = int(p.seed) + int(p.t / 2)
				var pts := PackedVector2Array([p.pos])
				var a := rng.randf() * TAU
				for k in 4:
					a += rng.randf_range(-0.8, 0.8)
					pts.append(pts[pts.size() - 1] + Vector2(cos(a), sin(a)) * p.r / 4.0)
				var c: Color = p.col
				c.a = 1.0 - u
				cv.draw_polyline(pts, c, 2.5, true)
			"dome":
				var grow := minf(1.0, u * 6.0)
				var fade := 1.0 - maxf(0.0, (u - 0.75) / 0.25)
				var rr: float = p.r * grow
				var c: Color = p.col
				cv.draw_colored_polygon(CharData.ellipse(p.pos, rr, rr * 0.8, 40), Color(c.r, c.g, c.b, 0.12 * fade))
				var edge := CharData.ellipse(p.pos, rr, rr * 0.8, 40)
				edge.append(edge[0])
				cv.draw_polyline(edge, Color(c.r, c.g, c.b, 0.7 * fade), 3.0, true)
				cv.draw_arc(p.pos, rr * 0.55, PI, TAU, 24, Color(c.r, c.g, c.b, 0.25 * fade), 2.0, true)
			"cube":
				var c: Color = p.col
				c.a = 1.0 - u
				var rr: float = p.r
				var pts := PackedVector2Array()
				for k in 4:
					var a: float = p.rot + p.t * 0.2 + TAU * k / 4.0
					pts.append(p.pos + Vector2(cos(a), sin(a)) * rr)
				pts.append(pts[0])
				cv.draw_polyline(pts, c, 2.5, true)
			"smoke":
				var c: Color = p.col
				c.a *= (1.0 - u)
				var r: float = p.r + p.get("grow", 0.3) * p.t
				cv.draw_texture_rect(PUFF, Rect2(p.pos - Vector2(r, r), Vector2(r, r) * 2.0), false, c)
			"drop":
				var c: Color = p.col
				c.a *= 1.0 - u * u
				var v: Vector2 = p.vel
				cv.draw_colored_polygon(CharData.capsule(p.pos - v * 0.8, p.pos, p.r * 0.5, p.r, 4), c)
			"flame":
				var c := Color(1.0, 0.95, 0.6).lerp(Color(1.0, 0.45, 0.05), minf(1.0, u * 2.0)).lerp(Color(0.6, 0.05, 0.0), maxf(0.0, u * 2.0 - 1.0))
				c.a = 0.95 * (1.0 - u)
				var r: float = p.r * (1.0 - u * 0.5)
				glow(cv, p.pos, r * 1.6, c)
				if u < 0.5:
					glow(cv, p.pos, r * 0.6, Color(1, 1, 0.85, (0.5 - u) * 1.6))
			"ember":
				var c := Color(1.0, 0.7, 0.2, 1.0 - u)
				cv.draw_circle(p.pos, p.r, c)
				glow(cv, p.pos, 10.0, Color(1.0, 0.4, 0.05, 0.7 * (1.0 - u)))


func _draw_arc_slash(cv: CanvasItem, p: Dictionary, u: float) -> void:
	# a crescent that sweeps open, then thins out
	var sweep := minf(1.0, u * 3.0)
	var thin := 1.0 - maxf(0.0, (u - 0.3) / 0.7)
	var r: float = p.r
	var w: float = p.w * thin
	if w < 0.8:
		return
	var span := PI * 0.95 * sweep
	var a0: float = p.ang - PI * 0.48
	var dirx: float = p.dir
	var outer := PackedVector2Array()
	var inner := PackedVector2Array()
	var n := 18
	for i in n + 1:
		var t := float(i) / n
		var a := a0 + span * t
		var k := sin(t * PI)
		var v := Vector2(cos(a) * dirx, sin(a))
		outer.append(p.pos + v * r)
		inner.append(p.pos + v * (r - w * k - 0.5))
	inner.reverse()
	var poly := outer + inner
	if Geometry2D.triangulate_polygon(poly).is_empty():
		return
	var c: Color = p.col
	c.a *= thin
	cv.draw_colored_polygon(poly, c)


func _draw_bolt(cv: CanvasItem, p: Dictionary, u: float) -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = int(p.seed) + int(p.t / 2)
	var top: Vector2 = p.pos + Vector2(rng.randf_range(-60, 60), -900.0)
	var bottom := Vector2(p.pos.x, 0.0)
	var pts := PackedVector2Array()
	var n := 14
	for k in n + 1:
		var q := top.lerp(bottom, float(k) / n)
		if k > 0 and k < n:
			q.x += rng.randf_range(-40.0, 40.0)
		pts.append(q)
	var a := 1.0 - u
	cv.draw_polyline(pts, Color(1.0, 0.85, 0.3, 0.5 * a), 22.0, true)
	cv.draw_polyline(pts, Color(1.0, 0.95, 0.6, 0.8 * a), 10.0, true)
	cv.draw_polyline(pts, Color(1, 1, 1, a), 4.0, true)
	for k in range(2, n - 1, 3):
		var b := pts[k]
		var br := PackedVector2Array([b, b + Vector2(rng.randf_range(-70, 70), rng.randf_range(20, 80))])
		cv.draw_polyline(br, Color(1, 0.95, 0.6, 0.7 * a), 3.0, true)


func _draw_speed(cv: CanvasItem, p: Dictionary, u: float) -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = int(p.seed) + int(p.t / 2)
	var c: Color = p.col
	c.a *= 1.0 - u * u
	for i in 44:
		var a := rng.randf() * TAU
		var d := Vector2(cos(a), sin(a))
		var r0 := rng.randf_range(260.0, 420.0)
		var r1 := r0 + rng.randf_range(300.0, 700.0)
		var w := rng.randf_range(2.0, 7.0)
		var nrm := Vector2(-d.y, d.x) * w
		cv.draw_colored_polygon(PackedVector2Array([p.pos + d * r0, p.pos + d * r1 + nrm, p.pos + d * r1 - nrm]), c)
