extends Node2D
## Draws one character from a pose. Used by fighters, menus and portraits.

var cd: CharData
var J := {}
var pose := {}
var st := {}

const SHADER := preload("res://shaders/rig.gdshader")


func _ready() -> void:
	var m := ShaderMaterial.new()
	m.shader = SHADER
	material = m


func set_pose(p: Dictionary, grounded := true) -> void:
	pose = p
	J = cd.joints(p, grounded)
	queue_redraw()


func _draw() -> void:
	if cd and not J.is_empty():
		if st.has("ground"):
			_shadow(float(st.ground))
		cd.draw(self, J, pose, st)


## Soft ground shadow that shrinks as the fighter rises.
func _shadow(g: float) -> void:
	var k := clampf(1.0 - g / 420.0, 0.35, 1.0)
	var x: float = J.hip.x
	for i in 3:
		var s := k * (1.0 - i * 0.22)
		var pts := CharData.ellipse(Vector2(x, g - 2.0), 70.0 * s, 13.0 * s, 20)
		draw_colored_polygon(pts, Color(0.02, 0.0, 0.05, 0.16 * k))
