extends Node2D
## Draws one character from a pose. Used by fighters, menus and portraits.

var cd: CharData
var J := {}
var pose := {}
var st := {}


func set_pose(p: Dictionary, grounded := true) -> void:
	pose = p
	J = cd.joints(p, grounded)
	queue_redraw()


func _draw() -> void:
	if cd and not J.is_empty():
		cd.draw(self, J, pose, st)
