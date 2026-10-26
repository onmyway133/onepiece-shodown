extends Node2D
## A fading afterimage of a fighter, drawn as a flat glowing silhouette.

var cd: CharData
var J := {}
var pose := {}
var life := 14
var t := 0
var col := Color.WHITE


func _ready() -> void:
	var mat := CanvasItemMaterial.new()
	mat.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
	material = mat


func _physics_process(_d: float) -> void:
	t += 1
	if t >= life:
		queue_free()
		return
	queue_redraw()


func _draw() -> void:
	var u := float(t) / life
	var c := Color(col.r, col.g, col.b, 0.4 * (1.0 - u))
	cd.draw(self, J, pose, {"flat": true, "tint": Color(c.r, c.g, c.b, 1.0), "time": 0.0, "alpha": c.a})
