extends Node
## Screen switcher: title -> select -> fight -> back.

var current: Node


func _ready() -> void:
	randomize()
	var args := OS.get_cmdline_user_args()
	for a in args:
		if a.begins_with("--debug"):
			goto("res://scripts/core/debug.gd")
			return
	goto("res://scripts/ui/title.gd")


func goto(script_path: String, data := {}) -> void:
	if current:
		current.queue_free()
	Engine.time_scale = 1.0
	get_tree().paused = false
	var script: GDScript = load(script_path)
	var n: Node = script.new()
	n.set_meta("data", data)
	if n.has_method("setup"):
		n.setup(data)
	current = n
	add_child(n)
