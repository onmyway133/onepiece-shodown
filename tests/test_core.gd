extends SceneTree
## Headless checks: godot --headless --path . --script res://tests/test_core.gd

var fails := 0


func check(cond: bool, msg: String) -> void:
	if not cond:
		fails += 1
		print("FAIL: ", msg)


func _inp(x: int, y: int) -> Dictionary:
	return {"x": x, "y": y}


func _init() -> void:
	var b := InputBuffer.new()
	# QCF facing right: down, down-forward, forward
	for d in [[0, -1], [1, -1], [1, 0]]:
		b.push(_inp(d[0], d[1]), 1)
	check(b.motion([2, 3, 6]), "qcf right")
	check(not b.motion([2, 1, 4]), "not qcb")
	b.clear()
	# same physical motion while facing left is a QCB
	for d in [[0, -1], [1, -1], [1, 0]]:
		b.push(_inp(d[0], d[1]), -1)
	check(b.motion([2, 1, 4]), "qcb when facing left")
	b.clear()
	for d in [[1, 0], [0, -1], [1, -1]]:
		b.push(_inp(d[0], d[1]), 1)
	check(b.motion([6, 2, 3]), "dp")
	b.clear()
	for d in [[1, 0], [1, 0], [0, 0], [0, 0], [1, 0]]:
		b.push(_inp(d[0], d[1]), 1)
	check(b.dash(1), "forward dash")
	# every move of every character resolves its poses and hits
	for id in ["luffy", "zoro", "sanji", "ace"]:
		var cd: CharData = load("res://scripts/chars/%s.gd" % id).new()
		for k in ["light", "heavy", "kick", "c_light", "c_heavy", "c_kick", "j_light", "j_heavy", "j_kick", "s1", "s1_h", "s2", "s3", "super"]:
			check(cd.moves.has(k), "%s has %s" % [id, k])
			if cd.moves.has(k):
				var m: Dictionary = cd.moves[k]
				check(int(m.total) > 0, "%s %s total" % [id, k])
				for h in m.hits:
					check(int(h.f[1]) <= int(m.total), "%s %s hit window inside move" % [id, k])
				for key in m["keys"]:
					var J := cd.joints(key[1], true)
					check(J.has("hand_f"), "%s %s joints" % [id, k])
	print("tests done, failures: ", fails)
	quit(1 if fails > 0 else 0)
