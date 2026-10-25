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


func _unhandled_input(event: InputEvent) -> void:
	# F11, or Alt/Cmd + Enter, toggles fullscreen
	if event is InputEventKey and event.pressed and not event.echo:
		var k: InputEventKey = event
		if k.physical_keycode == KEY_F11 or (k.physical_keycode == KEY_ENTER and (k.alt_pressed or k.meta_pressed)):
			var full := DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED if full else DisplayServer.WINDOW_MODE_FULLSCREEN)
