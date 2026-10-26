extends RefCounted
## CPU opponent. Produces the same input dictionaries a human would, using the
## "Special + direction" shortcuts for special moves.
## level: 0 easy .. 3 pirate king.

const REACT := [16, 10, 6, 3]
const BLOCK := [0.25, 0.55, 0.78, 0.93]
const AA := [0.15, 0.4, 0.65, 0.85]
const AGGRO := [0.35, 0.55, 0.7, 0.8]

var level := 1
var queue: Array = []
var think := 0
var guard_for := -1
var guard_decision := false
var last_opp_move := ""
var hold_dir := 0
var hold_t := 0


func _init(lv := 1) -> void:
	level = clampi(lv, 0, 3)


func _inp(x := 0, y := 0) -> Dictionary:
	var d := Controls.empty()
	d.x = x
	d.y = y
	return d


func _press(btn: String, x := 0, y := 0) -> Dictionary:
	var d := _inp(x, y)
	d[btn] = true
	d[btn + "_held"] = true
	return d


func get_input(f) -> Dictionary:
	var o = f.opp
	var fwd: int = f.facing
	if not queue.is_empty():
		var q: Array = queue[0]
		q[1] -= 1
		if q[1] <= 0:
			queue.pop_front()
		return q[0]
	var dist: float = absf(o.position.x - f.position.x)
	var away := -1 if o.position.x > f.position.x else 1

	# keep guarding through blockstun
	if f.state == "block":
		return _inp(away, -1 if o.is_attacking() and _opp_low(o) else 0)
	if not (f.state in ["idle", "walk_f", "walk_b", "crouch", "guard_hold", "air", "land"]):
		return _inp()

	# react to an incoming attack once per opponent move
	if o.is_threatening(f):
		if guard_for != _move_id(o):
			guard_for = _move_id(o)
			guard_decision = randf() < BLOCK[level]
		if guard_decision:
			return _inp(away, -1 if _opp_low(o) else 0)

	think -= 1
	if think > 0:
		if hold_t > 0:
			hold_t -= 1
			return _inp(hold_dir)
		return _inp()
	think = REACT[level] + randi_range(0, 6)

	# anti-air
	if o.is_airborne() and dist < 300.0 and o.vel.y > -6.0 and f.on_ground():
		if randf() < AA[level]:
			if f.cd.moves.has("s3") and randf() < 0.6:
				return _press("special", 0, 1)
			return _press("heavy", 0, -1)
	# super
	if f.can_super() and dist < 300.0 and randf() < 0.5:
		if f.cd.moves.has("super2") and randf() < 0.5:
			return _press("super", -fwd)
		return _press("super")
	if not f.on_ground():
		if dist < 220.0 and randf() < 0.6:
			return _press(["heavy", "kick", "light"][randi() % 3])
		return _inp()

	var r := randf()
	if dist > 520.0:
		if r < 0.25 and f.cd.get("ai_zoner"):
			return _press("special")
		elif r < 0.55:
			hold_dir = fwd
			hold_t = 22
			return _inp(fwd)
		elif r < 0.75:
			queue = [[_inp(fwd), 2], [_inp(), 2], [_inp(fwd), 2]]
			return _inp()
		elif r < 0.85:
			queue = [[_inp(fwd, 1), 4], [_inp(), 16], [_press("heavy"), 1]]
			return _inp()
		return _inp()
	if dist > 230.0:
		if r < AGGRO[level] * 0.35:
			return _press("special", fwd)
		elif r < 0.45:
			return _press("heavy")
		elif r < 0.55:
			return _press("kick")
		elif r < 0.68:
			queue = [[_inp(fwd, 1), 4], [_inp(), 13], [_press("heavy"), 1]]
			return _inp()
		elif r < 0.75 and f.cd.get("ai_zoner"):
			return _press("special")
		hold_dir = fwd
		hold_t = 14
		return _inp(fwd)
	# close range
	if dist < 140.0 and o.on_ground() and o.state in ["idle", "walk_f", "walk_b", "crouch", "guard_hold", "block"] and randf() < 0.18 + 0.08 * level:
		return _press("heavy", fwd)
	if r < 0.08 and f.cd.moves.has("s4"):
		return _press("special", 0, -1)
	if r < 0.14 and level >= 1:
		# heavy versions need the real motions
		if randf() < 0.5 and f.cd.moves.has("s2_h"):
			queue = [[_inp(0, -1), 2], [_inp(-fwd, -1), 2], [_inp(-fwd), 1], [_press("heavy", -fwd), 1]]
		elif f.cd.moves.has("s3_h"):
			queue = [[_inp(fwd), 2], [_inp(0, -1), 2], [_inp(fwd, -1), 1], [_press("heavy", fwd, -1), 1]]
		return _inp()
	if r < 0.25:
		queue = [[_inp(), 3], [_press("heavy"), 1]] if randf() < AGGRO[level] else []
		return _press("light")
	elif r < 0.4:
		return _press("kick", 0, -1)
	elif r < 0.52:
		return _press("heavy")
	elif r < 0.6:
		return _press("special", 0, 1) if randf() < 0.4 else _press("special")
	elif r < 0.7:
		queue = [[_inp(-fwd), 2], [_inp(), 2], [_inp(-fwd), 2]]
		return _inp()
	elif r < 0.8:
		return _press("light", 0, -1)
	hold_dir = -fwd if randf() < 0.4 else fwd
	hold_t = 10
	return _inp(hold_dir)


func _move_id(o) -> int:
	if o.state == "attack":
		return hash(String(o.move.get("name", ""))) ^ int(o.time * 60.0 - o.mf)
	return -2


func _opp_low(o) -> bool:
	if o.state != "attack":
		return false
	for h in o.move.get("hits", []):
		if h.lvl == "low":
			return true
	return false
