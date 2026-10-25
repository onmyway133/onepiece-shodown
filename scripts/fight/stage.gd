extends Node2D
## Parallax stage built from painted layers in res://assets/stages/<id>/ plus
## ambient particles (sakura petals, sand, sea spray).

const HALF := 1100.0
const LAYERS := {
	"merry": [["sky", 0.04], ["far", 0.22], ["mid", 0.5], ["ground", 1.0]],
	"wano": [["sky", 0.04], ["far", 0.22], ["mid", 0.5], ["ground", 1.0]],
	"alabasta": [["sky", 0.04], ["far", 0.22], ["mid", 0.5], ["ground", 1.0]],
}
const IMG_CENTER := Vector2(0, -325)

var id := "merry"
var sprites: Array = []
var ambient: Array = []
var t := 0.0
var _amb := Node2D.new()


func setup(stage_id: String) -> void:
	id = stage_id
	for l in LAYERS.get(id, LAYERS.merry):
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
			"sand":
				_amb.draw_line(a.p, a.p - a.v * 4.0, Color(0.95, 0.8, 0.55, 0.35), 2.0)
			"gull":
				var w := sin(a.t * 0.15) * 6.0
				_amb.draw_polyline(PackedVector2Array([a.p + Vector2(-12, -w), a.p, a.p + Vector2(12, -w)]), Color(0.2, 0.15, 0.2, 0.7), 2.0, true)
