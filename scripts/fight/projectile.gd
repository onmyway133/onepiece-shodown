extends Node2D
## A moving attack (wind blades, fire fists, fireflies...).
## def: {type, pos:[x,y] (local to owner), vel:[x,y], r, life, hp, hits, every, hit:{...}}

var owner_f
var def := {}
var vel := Vector2.ZERO
var facing := 1
var t := 0
var life := 90
var hp := 1
var hits_left := 1
var cooldown := 0
var r := 30.0
var hit := {}
var dead := false
var kind := ""
var size := 1.0


func setup(f, d: Dictionary) -> void:
	owner_f = f
	def = d
	facing = f.facing
	var p: Array = d.get("pos", [80, -140])
	position = f.world_point(Vector2(p[0], p[1]))
	var v: Array = d.get("vel", [10, 0])
	vel = Vector2(float(v[0]) * facing, float(v[1]))
	life = int(d.get("life", 90))
	hp = int(d.get("hp", 1))
	hits_left = int(d.get("hits", 1))
	r = float(d.get("r", 30.0))
	kind = String(d.get("type", "wind"))
	size = float(d.get("size", 1.0))
	hit = CharData.HIT_DEFAULTS.duplicate()
	hit.merge(d.get("hit", {}), true)
	hit["id"] = -1


func tick(fx) -> void:
	t += 1
	if cooldown > 0:
		cooldown -= 1
	var acc: Array = d_get("acc", [0, 0])
	vel += Vector2(float(acc[0]) * facing, float(acc[1]))
	if kind == "firefly":
		vel.y += sin(t * 0.25 + position.x * 0.01) * 0.35
	position += vel
	if t >= life or absf(position.x) > 1500.0 or position.y > 40.0:
		dead = true
	match kind:
		"fire_fist", "entei", "cross":
			if t % 2 == 0:
				fx.flame(position + Vector2(randf_range(-r, r) * 0.6, randf_range(-r, r) * 0.6), Vector2(-vel.x * 0.15, randf_range(-2.0, 0.0)), randf_range(r * 0.25, r * 0.5), randi_range(14, 26))
		"firefly":
			if t % 4 == 0:
				fx.flame(position, Vector2.ZERO, 6.0, 10)
		"wind":
			if t % 3 == 0:
				fx.smoke(position + Vector2(-facing * r * 0.5, randf_range(-r, r) * 0.5), Color(0.85, 1.0, 0.95, 0.3), 1.0)
	queue_redraw()


func d_get(k: String, default):
	return def.get(k, default)


func can_hit() -> bool:
	return not dead and cooldown == 0 and hits_left > 0


func on_hit() -> void:
	hits_left -= 1
	cooldown = int(def.get("every", 6))
	if hits_left <= 0:
		dead = true


func _draw() -> void:
	var fade := 1.0
	if life - t < 8:
		fade = (life - t) / 8.0
	match kind:
		"wind":
			_draw_wind(fade)
		"fire_fist":
			_draw_fire_fist(fade)
		"firefly":
			draw_circle(Vector2.ZERO, 9.0, Color(1.0, 0.6, 0.1, 0.5 * fade))
			draw_circle(Vector2.ZERO, 5.0, Color(1.0, 0.95, 0.5, fade))
		"entei":
			_draw_entei(fade)
		"cross":
			_draw_cross(fade)
		_:
			draw_circle(Vector2.ZERO, r, Color(1, 1, 1, 0.6 * fade))


func _crescent(rad: float, thick: float, c: Color, wobble := 0.0) -> void:
	var pts := PackedVector2Array()
	var n := 16
	for i in n + 1:
		var a := lerpf(-1.2, 1.2, float(i) / n)
		pts.append(Vector2(cos(a) * rad * facing, sin(a) * rad * 1.15))
	for i in range(n, -1, -1):
		var a := lerpf(-1.2, 1.2, float(i) / n)
		var k := 1.0 - pow(absf(a) / 1.2, 2.0)
		pts.append(Vector2(cos(a) * (rad - thick * k - wobble) * facing, sin(a) * rad * 1.15))
	draw_colored_polygon(pts, c)


func _draw_wind(fade: float) -> void:
	var s := r * size
	var wob := sin(t * 0.8) * 2.0
	_crescent(s * 1.3, s * 0.7, Color(0.4, 0.9, 0.8, 0.25 * fade), wob)
	_crescent(s * 1.15, s * 0.45, Color(0.75, 1.0, 0.95, 0.6 * fade))
	_crescent(s * 1.05, s * 0.18, Color(1, 1, 1, 0.95 * fade))
	for i in 3:
		var y := (i - 1) * s * 0.5
		draw_line(Vector2(-facing * s * 0.4, y), Vector2(-facing * s * 1.6, y), Color(1, 1, 1, 0.35 * fade), 2.0, true)


func _draw_fire_fist(fade: float) -> void:
	var s := r * size
	var flick := sin(t * 1.3) * 0.08 + 1.0
	draw_circle(Vector2.ZERO, s * 1.25 * flick, Color(1.0, 0.25, 0.0, 0.35 * fade))
	draw_circle(Vector2(facing * s * 0.1, 0), s * 0.95, Color(1.0, 0.5, 0.05, 0.7 * fade))
	draw_circle(Vector2(facing * s * 0.25, 0), s * 0.6, Color(1.0, 0.85, 0.3, 0.9 * fade))
	# knuckles
	for i in 4:
		var y := (i - 1.5) * s * 0.28
		draw_circle(Vector2(facing * s * 0.62, y), s * 0.17, Color(1.0, 0.97, 0.75, fade))
	# flame tail
	for i in 5:
		var off := Vector2(-facing * s * (0.8 + i * 0.35), sin(t * 0.7 + i) * s * 0.2)
		draw_circle(off, s * (0.7 - i * 0.11), Color(1.0, 0.35 + i * 0.05, 0.0, (0.55 - i * 0.09) * fade))


func _draw_entei(fade: float) -> void:
	var s := r * size
	var flick := 1.0 + sin(t * 0.9) * 0.05
	draw_circle(Vector2.ZERO, s * 1.35 * flick, Color(1.0, 0.2, 0.0, 0.25 * fade))
	draw_circle(Vector2.ZERO, s * 1.1, Color(1.0, 0.45, 0.0, 0.6 * fade))
	draw_circle(Vector2.ZERO, s * 0.85, Color(1.0, 0.7, 0.15, 0.85 * fade))
	draw_circle(Vector2.ZERO, s * 0.55, Color(1.0, 0.95, 0.6, fade))
	for i in 12:
		var a := TAU * i / 12.0 + t * 0.05
		var p := Vector2(cos(a), sin(a)) * s * (1.05 + 0.12 * sin(t * 0.6 + i))
		draw_circle(p, s * 0.22, Color(1.0, 0.5, 0.05, 0.6 * fade))


func _draw_cross(fade: float) -> void:
	var s := r * size
	var c1 := Color(1.0, 0.45, 0.05, 0.75 * fade)
	var c2 := Color(1.0, 0.9, 0.5, fade)
	var rot := 0.0
	for k in 2:
		var w := s * (0.35 if k == 0 else 0.16)
		var c := c1 if k == 0 else c2
		draw_set_transform(Vector2.ZERO, rot, Vector2.ONE)
		draw_rect(Rect2(-s, -w, s * 2, w * 2), c)
		draw_rect(Rect2(-w, -s, w * 2, s * 2), c)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
