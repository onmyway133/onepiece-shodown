extends Node2D
## Parallax stage built from painted layers in res://assets/stages/<id>/ plus
## ambient particles (sakura petals, sand, sea spray).

const HALF := 1100.0
const LAYERS := {
	"merry": [["sky", 0.04], ["far", 0.22], ["mid", 0.5], ["ground", 1.0]],
	"wano": [["sky", 0.04], ["far", 0.22], ["mid", 0.5], ["ground", 1.0]],
	"alabasta": [["sky", 0.04], ["far", 0.22], ["mid", 0.5], ["ground", 1.0]],
	"flower": [["sky", 0.04], ["far", 0.22], ["mid", 0.5], ["crowd", 0.62], ["ground", 1.0]],
}
const CROWD_F := 0.62
const KIMONO := ["8e2f3a", "2f4a7e", "3f6b4a", "6b3f7e", "a8722e", "3a3a46", "7e2f5e", "2f6b6b"]
const IMG_CENTER := Vector2(0, -325)

var id := "merry"
var sprites: Array = []
var ambient: Array = []
var t := 0.0
var _amb := Node2D.new()
var _crowd: Node2D
var people: Array = []


func setup(stage_id: String) -> void:
	id = stage_id
	for l in LAYERS.get(id, LAYERS.merry):
		if l[0] == "crowd":
			_make_crowd()
			continue
		var path := "res://assets/stages/%s/%s.png" % [id, l[0]]
		if not ResourceLoader.exists(path):
			continue
		var s := Sprite2D.new()
		s.texture = load(path)
		s.centered = true
		s.position = IMG_CENTER
		s.set_meta("f", l[1])
		add_child(s)
		sprites.append(s)
	add_child(_amb)
	_amb.draw.connect(_draw_ambient)


func _draw() -> void:
	if sprites.is_empty():
		# fallback when the painted layers are missing
		draw_rect(Rect2(-2000, -1200, 4000, 1200), Color("2b3d66"))
		draw_rect(Rect2(-2000, 0, 4000, 400), Color("4a3524"))


func follow(cam_pos: Vector2) -> void:
	for s in sprites:
		var f: float = s.get_meta("f")
		s.position = IMG_CENTER + Vector2(cam_pos.x * (1.0 - f), cam_pos.y * (1.0 - f) * 0.3)
	if _crowd:
		_crowd.position = Vector2(cam_pos.x * (1.0 - CROWD_F), cam_pos.y * (1.0 - CROWD_F) * 0.3)
		_crowd.queue_redraw()
	t += 1.0 / 60.0
	_spawn(cam_pos)
	_amb.queue_redraw()


func _spawn(cam: Vector2) -> void:
	match id:
		"wano":
			if randf() < 0.35:
				ambient.append({"p": cam + Vector2(randf_range(-800, 900), -520), "v": Vector2(randf_range(-1.6, -0.4), randf_range(1.0, 2.0)), "life": 500, "t": 0, "rot": randf() * TAU, "k": "petal"})
		"alabasta":
			if randf() < 0.5:
				ambient.append({"p": cam + Vector2(900, randf_range(-500, 40)), "v": Vector2(randf_range(-7, -3), randf_range(-0.3, 0.3)), "life": 400, "t": 0, "rot": 0.0, "k": "sand"})
		"flower":
			if randf() < 0.25:
				ambient.append({"p": cam + Vector2(randf_range(-800, 900), -520), "v": Vector2(randf_range(-1.4, -0.3), randf_range(0.9, 1.8)), "life": 500, "t": 0, "rot": randf() * TAU, "k": "petal"})
			if randf() < 0.06:
				ambient.append({"p": cam + Vector2(randf_range(-700, 700), randf_range(-60, 0)), "v": Vector2(randf_range(-0.3, 0.3), randf_range(-1.0, -0.4)), "life": 260, "t": 0, "rot": randf() * TAU, "k": "ember"})
		"merry":
			if randf() < 0.08:
				ambient.append({"p": cam + Vector2(randf_range(-800, 800), -560), "v": Vector2(randf_range(-0.8, -0.2), randf_range(0.2, 0.5)), "life": 900, "t": 0, "rot": 0.0, "k": "gull"})
	var i := 0
	while i < ambient.size():
		var a: Dictionary = ambient[i]
		a.t += 1
		a.p += a.v
		if a.k == "petal":
			a.v.x += sin(t * 2.0 + a.rot) * 0.03
			a.rot += 0.05
		if a.t > a.life or a.p.y > 60:
			ambient.remove_at(i)
		else:
			i += 1


func _draw_ambient() -> void:
	for a in ambient:
		match String(a.k):
			"petal":
				var pts := PackedVector2Array()
				for k in 6:
					var ang := TAU * k / 6.0
					pts.append(a.p + Vector2(cos(ang) * 6.0, sin(ang) * 3.2).rotated(a.rot))
				_amb.draw_colored_polygon(pts, Color(1.0, 0.75, 0.85, 0.9))
			"ember":
				var fade: float = 1.0 - float(a.t) / float(a.life)
				_amb.draw_circle(a.p, 7.0, Color(1.0, 0.6, 0.2, 0.18 * fade))
				_amb.draw_circle(a.p, 2.4, Color(1.0, 0.85, 0.5, 0.9 * fade))
			"sand":
				_amb.draw_line(a.p, a.p - a.v * 4.0, Color(0.95, 0.8, 0.55, 0.35), 2.0)
			"gull":
				var w := sin(a.t * 0.15) * 6.0
				_amb.draw_polyline(PackedVector2Array([a.p + Vector2(-12, -w), a.p, a.p + Vector2(12, -w)]), Color(0.2, 0.15, 0.2, 0.7), 2.0, true)


# ---------------------------------------------------------------- crowd

## The Flower Capital crowd: two rows of townsfolk that bob and cheer.
func _make_crowd() -> void:
	_crowd = Node2D.new()
	add_child(_crowd)
	_crowd.draw.connect(_draw_crowd)
	var rng := RandomNumberGenerator.new()
	rng.seed = 2024
	for row in 2:
		var x := -1500.0 + rng.randf() * 40.0
		while x < 1500.0:
			people.append({"x": x, "row": row, "h": rng.randf_range(0.85, 1.1), "c": Color(KIMONO[rng.randi() % KIMONO.size()]),
				"skin": Color("e8b48a").darkened(rng.randf_range(0.0, 0.25)), "ph": rng.randf() * TAU, "sp": rng.randf_range(4.0, 7.0),
				"cheer": rng.randf() < 0.45, "hat": rng.randf() < 0.2, "bun": rng.randf() < 0.3})
			x += rng.randf_range(38.0, 70.0) if row == 0 else rng.randf_range(44.0, 80.0)


func _draw_crowd() -> void:
	for row in 2:
		for p in people:
			if p.row == row:
				_draw_person(p)


func _draw_person(p: Dictionary) -> void:
	var back: bool = p.row == 0
	var k: float = (0.7 if back else 0.85) * p.h
	var dark := 0.62 if back else 0.4
	var bob: float = absf(sin(t * p.sp + p.ph)) * (6.0 if p.cheer else 2.0)
	var base := Vector2(p.x + (12.0 if back else 0.0), (-62.0 if back else -34.0) - bob)
	var body: Color = Color(p.c).darkened(dark)
	var skin: Color = Color(p.skin).darkened(dark + 0.1)
	var hair := Color(0.06, 0.05, 0.07)
	var rim := Color(1.0, 0.7, 0.4, 0.35 if back else 0.5)
	# kimono body
	var w := 26.0 * k
	var h := 110.0 * k
	var pts := PackedVector2Array([base + Vector2(-w, 0), base + Vector2(w, 0), base + Vector2(w * 0.8, -h), base + Vector2(-w * 0.8, -h)])
	_crowd.draw_colored_polygon(pts, body)
	_crowd.draw_line(base + Vector2(w * 0.8, -h), base + Vector2(w, 0), rim, 2.0)
	_crowd.draw_line(base + Vector2(-w * 0.1, -h), base + Vector2(w * 0.3, -h * 0.55), Color(1, 1, 1, 0.15), 2.0)
	# arms: raised and waving when cheering
	var sh := base + Vector2(0, -h + 10.0 * k)
	for s in [-1.0, 1.0]:
		var ang := deg_to_rad(-150.0 + 25.0 * sin(t * p.sp * 1.3 + p.ph + s)) if p.cheer else deg_to_rad(10.0)
		var hand: Vector2 = sh + Vector2(s * w * 0.7, 0) + Vector2(sin(ang) * s, cos(ang)) * 60.0 * k
		_crowd.draw_line(sh + Vector2(s * w * 0.7, 0), hand, body, 12.0 * k)
		_crowd.draw_circle(hand, 6.0 * k, skin)
	# head
	var head := base + Vector2(0, -h - 20.0 * k)
	_crowd.draw_circle(head, 19.0 * k, skin)
	_crowd.draw_arc(head, 19.0 * k, -PI * 0.4, PI * 0.3, 8, rim, 2.0)
	if p.hat:
		_crowd.draw_colored_polygon(PackedVector2Array([head + Vector2(-34, -6) * k, head + Vector2(34, -6) * k, head + Vector2(0, -30) * k]), Color(0.45, 0.36, 0.22).darkened(dark))
	else:
		_crowd.draw_colored_polygon(PackedVector2Array([head + Vector2(-20, 2) * k, head + Vector2(-18, -14) * k, head + Vector2(0, -22) * k, head + Vector2(18, -14) * k, head + Vector2(20, -2) * k]), hair)
		if p.bun:
			_crowd.draw_circle(head + Vector2(0, -24) * k, 9.0 * k, hair)
