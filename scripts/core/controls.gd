extends Node
## Builds the input map at startup so the project needs no editor setup.
## P1: WASD + F G H T Y (or J K L I U).  P2: arrows + , . / ; ' (or numpad 1-5).
## Gamepad 1 drives P1 and gamepad 2 drives P2.

const ACTIONS := ["up", "down", "left", "right", "light", "heavy", "kick", "special", "super"]

const KEYS := {
	1: {
		"up": [KEY_W], "down": [KEY_S], "left": [KEY_A], "right": [KEY_D],
		"light": [KEY_F, KEY_J], "heavy": [KEY_G, KEY_K], "kick": [KEY_H, KEY_L],
		"special": [KEY_T, KEY_I], "super": [KEY_Y, KEY_U],
	},
	2: {
		"up": [KEY_UP], "down": [KEY_DOWN], "left": [KEY_LEFT], "right": [KEY_RIGHT],
		"light": [KEY_COMMA, KEY_KP_1], "heavy": [KEY_PERIOD, KEY_KP_2], "kick": [KEY_SLASH, KEY_KP_3],
		"special": [KEY_SEMICOLON, KEY_KP_4], "super": [KEY_APOSTROPHE, KEY_KP_5],
	},
}

const PAD := {
	"up": [JOY_BUTTON_DPAD_UP], "down": [JOY_BUTTON_DPAD_DOWN],
	"left": [JOY_BUTTON_DPAD_LEFT], "right": [JOY_BUTTON_DPAD_RIGHT],
	"light": [JOY_BUTTON_X], "heavy": [JOY_BUTTON_Y], "kick": [JOY_BUTTON_A],
	"special": [JOY_BUTTON_B], "super": [JOY_BUTTON_RIGHT_SHOULDER, JOY_BUTTON_LEFT_SHOULDER],
}

const PAD_AXES := {
	"up": [JOY_AXIS_LEFT_Y, -1.0], "down": [JOY_AXIS_LEFT_Y, 1.0],
	"left": [JOY_AXIS_LEFT_X, -1.0], "right": [JOY_AXIS_LEFT_X, 1.0],
}

## Synthetic inputs (for the CPU or automated tests) keyed by player.
var injected := {}


func _ready() -> void:
	for p in [1, 2]:
		for a in ACTIONS:
			var act := "p%d_%s" % [p, a]
			if InputMap.has_action(act):
				InputMap.erase_action(act)
			InputMap.add_action(act, 0.45)
			for k in KEYS[p][a]:
				var ev := InputEventKey.new()
				ev.physical_keycode = k
				InputMap.action_add_event(act, ev)
			for b in PAD[a]:
				var jb := InputEventJoypadButton.new()
				jb.button_index = b
				jb.device = p - 1
				InputMap.action_add_event(act, jb)
			if PAD_AXES.has(a):
				var jm := InputEventJoypadMotion.new()
				jm.axis = PAD_AXES[a][0]
				jm.axis_value = PAD_AXES[a][1]
				jm.device = p - 1
				InputMap.action_add_event(act, jm)
	_add_menu("pause", [KEY_ESCAPE, KEY_ENTER, KEY_P], [JOY_BUTTON_START])


func _add_menu(act: String, keys: Array, pads: Array) -> void:
	if not InputMap.has_action(act):
		InputMap.add_action(act)
	for k in keys:
		var ev := InputEventKey.new()
		ev.physical_keycode = k
		InputMap.action_add_event(act, ev)
	for b in pads:
		for d in [0, 1]:
			var jb := InputEventJoypadButton.new()
			jb.button_index = b
			jb.device = d
			InputMap.action_add_event(act, jb)


## Reads one player's controls this physics frame.
## Returns {x, y, light, heavy, kick, special, super (pressed this frame), and *_held}.
## y is +1 for up, -1 for down. With merge=true both keyboard halves drive the player.
func read(p: int, merge := false) -> Dictionary:
	var players := [p]
	if merge:
		players = [1, 2]
	var r := {"x": 0, "y": 0}
	var held := {}
	for a in ACTIONS:
		r[a] = false
		held[a] = false
	for q in players:
		for a in ACTIONS:
			var act := "p%d_%s" % [q, a]
			if Input.is_action_pressed(act):
				held[a] = true
			if Input.is_action_just_pressed(act):
				r[a] = true
	r.x = int(held.right) - int(held.left)
	r.y = int(held.up) - int(held.down)
	for a in ["light", "heavy", "kick", "special", "super"]:
		r[a + "_held"] = held[a]
	return r


func empty() -> Dictionary:
	var r := {"x": 0, "y": 0}
	for a in ["light", "heavy", "kick", "special", "super"]:
		r[a] = false
		r[a + "_held"] = false
	return r


## Menu helper: any player's direction or confirm this frame (works in _process too).
func menu_pressed(p: int, a: String) -> bool:
	return Input.is_action_just_pressed("p%d_%s" % [p, a])
