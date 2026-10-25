extends Node2D
## Particle and impact effects drawn in world space, plus weapon trails.
## Two layers: normal (smoke, dust, trails) and additive (sparks, fire, glows).

var fighters: Array = []
var _norm := Node2D.new()
var _add := Node2D.new()
var parts_n: Array = []
var parts_a: Array = []


func _ready() -> void:
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
	if list.size() < 900:
		list.append(d)


# ---------------------------------------------------------------- emitters

func spark(pos: Vector2, kind: String, facing: int) -> void:
	var dirx := float(facing)
	match kind:
		"block":
			_p(parts_a, {"k": "ring", "pos": pos, "r0": 10.0, "r1": 55.0, "life": 12, "col": Color(0.5, 0.8, 1.0), "w": 5.0})
			for i in 7:
				var a := randf_range(-1.2, 1.2) + (PI if dirx > 0 else 0.0)
				_p(parts_a, {"k": "line", "pos": pos, "vel": Vector2(cos(a), sin(a)) * randf_range(6, 12), "life": 10, "len": 22.0, "w": 3.0, "col": Color(0.7, 0.9, 1.0), "drag": 0.85})
		"slash":
			var ang := randf_range(-0.6, 0.6) + (0.0 if randf() < 0.5 else PI / 2.0)
			_p(parts_a, {"k": "slash", "pos": pos, "ang": ang, "len": 240.0, "life": 14, "col": Color(1.0, 0.35, 0.25)})
			_p(parts_a, {"k": "star", "pos": pos, "r": 70.0, "life": 9, "col": Color(1, 0.9, 0.7)})
			for i in 14:
				var a := randf() * TAU
				_p(parts_a, {"k": "line", "pos": pos, "vel": Vector2(cos(a), sin(a)) * randf_range(8, 20), "life": randi_range(10, 18), "len": 30.0, "w": 3.0, "col": Color(1.0, 0.8, 0.5), "drag": 0.86})
		"fire":
			_p(parts_a, {"k": "star", "pos": pos, "r": 80.0, "life": 9, "col": Color(1, 0.6, 0.2)})
			for i in 16:
				var a := randf() * TAU
				_p(parts_a, {"k": "flame", "pos": pos + Vector2(cos(a), sin(a)) * 10.0, "vel": Vector2(cos(a), sin(a)) * randf_range(3, 9), "life": randi_range(16, 30), "r": randf_range(10, 22), "drag": 0.9, "rise": 0.15})
		"heavy":
			_p(parts_a, {"k": "star", "pos": pos, "r": 95.0, "life": 10, "col": Color(1, 0.95, 0.75)})
			_p(parts_a, {"k": "ring", "pos": pos, "r0": 20.0, "r1": 120.0, "life": 14, "col": Color(1, 0.85, 0.5), "w": 6.0})
			for i in 18:
				var a := randf() * TAU
				_p(parts_a, {"k": "line", "pos": pos, "vel": Vector2(cos(a), sin(a)) * randf_range(10, 24), "life": randi_range(10, 20), "len": 38.0, "w": 4.0, "col": Color(1.0, 0.85, 0.4), "drag": 0.85})
		_:
			_p(parts_a, {"k": "star", "pos": pos, "r": 55.0, "life": 7, "col": Color(1, 0.95, 0.8)})
			for i in 9:
				var a := randf() * TAU
				_p(parts_a, {"k": "line", "pos": pos, "vel": Vector2(cos(a), sin(a)) * randf_range(7, 15), "life": randi_range(8, 13), "len": 24.0, "w": 3.0, "col": Color(1.0, 0.9, 0.5), "drag": 0.85})


func dust(pos: Vector2, dirx: int) -> void:
	for i in 8:
		var v := Vector2(randf_range(-3, 3) + dirx * 3.0, randf_range(-2.5, -0.5))
		_p(parts_n, {"k": "smoke", "pos": pos + Vector2(randf_range(-30, 30), -6), "vel": v, "life": randi_range(22, 36), "r": randf_range(10, 20), "grow": 0.6, "col": Color(0.85, 0.78, 0.66, 0.55), "drag": 0.92})


func smoke(pos: Vector2, c: Color, scale := 1.0) -> void:
	_p(parts_n, {"k": "smoke", "pos": pos, "vel": Vector2(randf_range(-0.6, 0.6), randf_range(-2.4, -1.2)), "life": randi_range(26, 40), "r": 8.0 * scale, "grow": 0.5 * scale, "col": c, "drag": 0.97})


func flame(pos: Vector2, vel: Vector2, r := 14.0, life := 22) -> void:
	_p(parts_a, {"k": "flame", "pos": pos, "vel": vel, "life": life, "r": r, "drag": 0.94, "rise": 0.12})


func ring(pos: Vector2, c: Color, r1 := 120.0, life := 16, w := 6.0) -> void:
	_p(parts_a, {"k": "ring", "pos": pos, "r0": 10.0, "r1": r1, "life": life, "col": c, "w": w})


func burst(name: String, pos: Vector2, facing: int) -> void:
	match name:
		"fire_burst":
			for i in 30:
				var a := randf() * TAU
				flame(pos + Vector2(cos(a), sin(a)) * 20.0, Vector2(cos(a), sin(a)) * randf_range(3, 10), randf_range(14, 30), randi_range(20, 40))
			ring(pos, Color(1, 0.5, 0.1), 180.0, 18, 10.0)
		"fire_trail":
			for i in 4:
				flame(pos + Vector2(randf_range(-20, 20), randf_range(-20, 20)), Vector2(-facing * randf_range(1, 3), randf_range(-2, 0)), randf_range(10, 20))
		"shock":
			ring(pos, Color(1, 1, 1), 160.0, 14, 8.0)
			ring(pos, Color(0.5, 0.8, 1), 100.0, 18, 5.0)
		"dark_ring":
			ring(pos, Color(0.7, 0.3, 1.0), 200.0, 22, 8.0)
		"tornado":
			for i in 22:
				var a := randf() * TAU
				_p(parts_a, {"k": "line", "pos": pos + Vector2(randf_range(-60, 60), randf_range(-120, 40)), "vel": Vector2(cos(a) * 14.0, -randf_range(4, 10)), "life": randi_range(10, 22), "len": 40.0, "w": 3.0, "col": Color(0.7, 1.0, 0.85), "drag": 0.9})
		"smoke_puff":
			for i in 10:
				smoke(pos + Vector2(randf_range(-30, 30), randf_range(-20, 20)), Color(0.9, 0.9, 0.95, 0.6), 2.0)
		"dust":
			dust(pos, facing)
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
		_draw_trail(_norm, f)
	_draw_list(_norm, parts_n)


func _draw_add() -> void:
	_draw_list(_add, parts_a)


func _draw_trail(cv: CanvasItem, f) -> void:
	var tr: Array = f.trail
	if tr.size() < 2:
		return
	var c: Color = f.cd.trail_color
	for i in range(1, tr.size()):
		var a: Array = tr[i - 1]
		var b: Array = tr[i]
		var alpha := float(i) / tr.size() * 0.75
		var q := PackedVector2Array([a[1], b[1], b[0], a[0]])
		if _valid_quad(q):
			cv.draw_colored_polygon(q, Color(c.r, c.g, c.b, alpha))
	var last: Array = tr[tr.size() - 1]
	cv.draw_line(last[0], last[1], Color(1, 1, 1, 0.7), 3.0, true)


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
				cv.draw_arc(p.pos, lerpf(p.r0, p.r1, sqrt(u)), 0.0, TAU, 32, c, p.w * (1.0 - u * 0.6), true)
			"star":
				var c: Color = p.col
				c.a = 1.0 - u
				var r: float = p.r * (1.0 - u * 0.5)
				var pts := PackedVector2Array()
				for k in 16:
					var a: float = TAU * k / 16.0 + p.t * 0.05
					var rr := r if k % 2 == 0 else r * 0.28
					pts.append(p.pos + Vector2(cos(a), sin(a)) * rr)
				cv.draw_colored_polygon(pts, c)
				cv.draw_circle(p.pos, r * 0.3, Color(1, 1, 1, 1.0 - u))
			"slash":
				var c: Color = p.col
				var dirv := Vector2(cos(p.ang), sin(p.ang))
				var n := Vector2(-dirv.y, dirv.x)
				var l: float = p.len * (0.6 + u * 0.4)
				var w := 16.0 * (1.0 - u)
				var poly := PackedVector2Array([p.pos - dirv * l, p.pos + n * w, p.pos + dirv * l, p.pos - n * w])
				cv.draw_colored_polygon(poly, Color(c.r, c.g, c.b, 1.0 - u))
				var core := PackedVector2Array([p.pos - dirv * l * 0.9, p.pos + n * w * 0.35, p.pos + dirv * l * 0.9, p.pos - n * w * 0.35])
				cv.draw_colored_polygon(core, Color(1, 1, 1, 1.0 - u))
			"smoke":
				var c: Color = p.col
				c.a *= (1.0 - u)
				cv.draw_circle(p.pos, p.r + p.get("grow", 0.3) * p.t, c)
			"flame":
				var c := Color(1.0, 0.95, 0.6).lerp(Color(1.0, 0.45, 0.05), minf(1.0, u * 2.0)).lerp(Color(0.6, 0.05, 0.0), maxf(0.0, u * 2.0 - 1.0))
				c.a = 0.9 * (1.0 - u)
				cv.draw_circle(p.pos, p.r * (1.0 - u * 0.6), c)
