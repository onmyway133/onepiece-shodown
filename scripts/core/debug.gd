extends Node2D
## Developer tool: renders pose / move sheets or runs a scripted fight and saves screenshots.
## godot --path . -- --debug=poses --char=luffy --shot=/tmp/x.png

const Rig := preload("res://scripts/fight/rig.gd")

var args := {}
var frames := 0


func _ready() -> void:
	for a in OS.get_cmdline_user_args():
		var kv := a.trim_prefix("--").split("=", true, 1)
		args[kv[0]] = kv[1] if kv.size() > 1 else "1"
	var kind: String = args.get("debug", "poses")
	if kind == "fight":
		Game.p1_char = args.get("p1", "luffy")
		Game.p2_char = args.get("p2", "zoro")
		Game.stage = args.get("stage", "merry")
		Game.mode = "demo"
		get_parent().call_deferred("goto", "res://scripts/fight/fight.gd", {"debug": args})
		return
	if kind == "flow":
		# simulates a player going through the menus, saving screenshots on the way
		var tree := get_tree()
		var shot: String = args.get("shot", "/tmp/flow.png")
		var steps := [[1.0, KEY_ENTER], [1.6, KEY_D], [1.9, KEY_F], [2.3, KEY_D], [2.6, KEY_F], [3.0, KEY_D], [3.4, KEY_F], [9.0, KEY_ESCAPE], [9.6, KEY_S], [10.0, KEY_ENTER], [11.0, KEY_ESCAPE], [11.5, KEY_ENTER]]
		var shots := [1.4, 2.8, 3.2, 6.0, 8.5, 9.3, 10.6, 12.5]
		get_parent().call_deferred("goto", "res://scripts/ui/title.gd")
		for st in steps:
			tree.create_timer(st[0]).timeout.connect(func():
				for pressed in [true, false]:
					var ev := InputEventKey.new()
					ev.physical_keycode = st[1]
					ev.keycode = st[1]
					ev.pressed = pressed
					Input.parse_input_event(ev)
					await tree.process_frame
					await tree.process_frame)
		for i in shots.size():
			var at: float = shots[i]
			tree.create_timer(at).timeout.connect(func():
				tree.root.get_texture().get_image().save_png(shot.replace(".png", "_%02d.png" % i)))
		tree.create_timer(13.0).timeout.connect(func(): tree.quit())
		return
	if kind == "screen":
		get_parent().call_deferred("goto", "res://scripts/ui/%s.gd" % args.get("screen", "title"))
		var tree := get_tree()
		var shot: String = args.get("shot", "/tmp/screen.png")
		var timer := tree.create_timer(float(args.get("wait", "1.5")))
		timer.timeout.connect(func():
			tree.root.get_texture().get_image().save_png(shot)
			tree.quit())
		return
	var cd := Game.char_data(args.get("char", "luffy"))
	var list := []
	if kind == "poses":
		for k in cd.poses:
			list.append([k, cd.pose(k)])
	else:
		var m: Dictionary = cd.moves[args.get("move", "light")]
		for k in m["keys"]:
			list.append([m.name + " " + str(k[0]), k[1]])
	var bg := ColorRect.new()
	bg.color = Color("6d8fb3")
	bg.size = Vector2(1280, 720)
	add_child(bg)
	if args.has("only"):
		var keep: PackedStringArray = String(args.only).split(",")
		list = list.filter(func(e): return e[0] in keep)
	var sc := float(args.get("scale", "0.55"))
	var cols := int(6 * 0.55 / sc)
	for i in list.size():
		var r := Rig.new()
		r.cd = cd
		r.st = {"time": 0.0}
		var cw := 210.0 * sc / 0.55
		var chh := 330.0 * sc / 0.55
		var rows := int(ceil(list.size() / float(cols)))
		r.position = Vector2(cw * 0.5 + (i % cols) * cw, 690.0 - (rows - 1 - i / cols) * chh)
		r.scale = Vector2(sc, sc)
		add_child(r)
		r.set_pose(list[i][1], true)
		var l := Label.new()
		l.text = list[i][0]
		l.position = r.position + Vector2(-90, 8)
		l.add_theme_color_override("font_color", Color.BLACK)
		add_child(l)
		draw_ground(r.position)


func draw_ground(p: Vector2) -> void:
	var g := ColorRect.new()
	g.color = Color(0, 0, 0, 0.3)
	g.position = p + Vector2(-100, 0)
	g.size = Vector2(200, 2)
	add_child(g)


func _process(_d: float) -> void:
	frames += 1
	if frames == 4 and args.has("shot"):
		get_viewport().get_texture().get_image().save_png(args.shot)
		get_tree().quit()
