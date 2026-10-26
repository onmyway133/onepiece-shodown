extends CharData
## Vinsmoke Sanji: fast kick fighter, flaming Diable Jambe.


func setup() -> void:
	id = "sanji"
	display_name = "SANJI"
	epithet = "Black Leg"
	quote = "A cook never wastes food... or a chance to kick."
	accent = Color("e3b33a")
	trail_color = Color(1.0, 0.85, 0.55)
	dims.thigh = 62.0
	dims.shin = 64.0
	dims.torso = 76.0
	dims.head = 23.0
	dims.ua = 41.0
	dims.fa = 39.0
	dims.chest = 1.14
	dims.limb = 0.95
	col.skin = Color("f3cfa8")
	col.hair = Color("f5d45a")
	col.top = Color("24262f")
	col.sleeve = Color("24262f")
	col.pants = Color("24262f")
	col.shoes = Color("121214")
	col.eye = Color("2a3d6b")
	style = {"top": "suit", "sleeves": "long", "pants": "long", "feet": "shoe", "cuff": false}
	walk_speed = 4.9
	back_speed = 3.9
	jump_vy = -20.5
	dash_speed = 15.0
	max_hp = 950.0

	# hands in pockets, relaxed lean
	poses.idle = {"t": 6.0, "head": -8.0, "ua_f": -8.0, "fa_f": 30.0, "ua_b": -14.0, "fa_b": 20.0, "th_f": 22.0, "sh_f": 2.0, "th_b": -16.0, "sh_b": -22.0, "hx": -4.0}
	poses.idle_b = {"hy": 2.0, "t": 8.0, "head": -10.0, "ua_f": -6.0, "fa_f": 34.0, "ua_b": -12.0, "fa_b": 24.0, "th_f": 24.0, "sh_f": -2.0, "th_b": -17.0, "sh_b": -20.0, "hx": -4.0}
	poses.walk1 = {"th_f": 32.0, "sh_f": 6.0, "th_b": -26.0, "sh_b": -28.0, "t": 6.0}
	poses.walk2 = {"th_f": 8.0, "sh_f": -28.0, "th_b": -4.0, "sh_b": -10.0, "t": 6.0, "hy": -3.0}
	poses.guard = {"t": -6.0, "head": 6.0, "ua_f": 60.0, "fa_f": 170.0, "ua_b": 50.0, "fa_b": 160.0, "th_f": 70.0, "sh_f": 60.0, "th_b": -14.0, "sh_b": -16.0, "face": "angry"}
	poses.win = {"t": 2.0, "head": -16.0, "ua_f": 140.0, "fa_f": 70.0, "ua_b": -14.0, "fa_b": 20.0, "th_f": 12.0, "sh_f": 0.0, "th_b": -10.0, "sh_b": -4.0, "face": "grin", "fx": "smoke"}
	poses.intro = {"t": 0.0, "head": -10.0, "ua_f": 130.0, "fa_f": 60.0, "ua_b": -10.0, "fa_b": 20.0, "th_f": 8.0, "sh_f": 0.0, "th_b": -8.0, "sh_b": -2.0, "face": "closed", "fx": "smoke"}
	poses.hand = {"rot": 180.0, "t": 0.0, "head": 0.0, "ua_f": 178.0, "fa_f": 180.0, "ua_b": 182.0, "fa_b": 180.0, "th_f": 70.0, "sh_f": 80.0, "th_b": -70.0, "sh_b": -80.0, "face": "angry"}

	var kick_f := {"t": -14.0, "head": 8.0, "th_f": 88.0, "sh_f": 86.0, "th_b": -10.0, "sh_b": -16.0, "ua_f": -20.0, "fa_f": 20.0, "face": "attack"}
	moves.light = {
		"anim": [[3, {"t": -4.0, "th_f": 60.0, "sh_f": 0.0}], [2, kick_f], [3, kick_f], [8, "idle"]],
		"hits": [{"f": [4, 8], "seg": "foot_f", "r": 18.0, "dmg": 40.0, "stun": 13, "bstun": 9, "kb": 4.5, "hs": 6, "sfx": "hit_l"}],
		"sfx": [[2, "swing_l"]], "trail": "foot_f", "cancel": true, "chain": ["heavy", "kick"],
	}
	moves.heavy = {
		"title": "MOUTON SHOT!",
		"anim": [[9, {"t": 18.0, "head": -20.0, "rot": -20.0, "th_f": 40.0, "sh_f": -40.0, "th_b": -6.0, "sh_b": -4.0, "face": "angry"}],
			[3, {"t": -34.0, "head": 20.0, "th_f": 128.0, "sh_f": 138.0, "th_b": -6.0, "sh_b": -6.0, "ua_f": -40.0, "fa_f": 0.0, "ua_b": -50.0, "fa_b": -20.0, "face": "shout"}],
			[5, {"t": -36.0, "head": 20.0, "th_f": 132.0, "sh_f": 140.0, "th_b": -6.0, "sh_b": -6.0, "ua_f": -40.0, "fa_f": 0.0, "ua_b": -50.0, "fa_b": -20.0, "face": "shout"}], [14, "idle"]],
		"hits": [{"f": [10, 16], "seg": "leg_f", "r": 24.0, "dmg": 105.0, "stun": 22, "bstun": 16, "kb": 9.0, "hs": 12, "spark": "heavy", "sfx": "hit_h"}],
		"sfx": [[8, "swing_h"]], "trail": "foot_f", "cancel": true,
	}
	moves.kick = {
		"title": "",
		"anim": [[6, {"t": 20.0, "th_f": 80.0, "sh_f": -40.0}], [3, {"t": -30.0, "head": 16.0, "th_f": 94.0, "sh_f": 94.0, "th_b": -8.0, "sh_b": -10.0, "ua_f": -40.0, "fa_f": 10.0, "face": "attack"}],
			[5, {"t": -30.0, "head": 16.0, "th_f": 94.0, "sh_f": 94.0, "th_b": -8.0, "sh_b": -10.0, "ua_f": -40.0, "fa_f": 10.0, "face": "attack"}], [11, "idle"]],
		"hits": [{"f": [8, 14], "seg": "leg_f", "r": 22.0, "dmg": 70.0, "stun": 18, "bstun": 12, "kb": 9.0, "hs": 9}],
		"sfx": [[5, "swing_m"]], "trail": "foot_f", "cancel": true,
	}
	moves.c_light = {
		"anim": [[3, {"base": "crouch", "th_f": 60.0, "sh_f": 20.0}], [2, {"base": "crouch", "th_f": 85.0, "sh_f": 90.0, "face": "attack"}], [4, {"base": "crouch", "th_f": 85.0, "sh_f": 90.0}], [8, "crouch"]],
		"hits": [{"f": [4, 8], "seg": "foot_f", "r": 16.0, "dmg": 32.0, "stun": 13, "bstun": 8, "kb": 4.0, "lvl": "low", "hs": 5, "sfx": "hit_l"}],
		"sfx": [[2, "swing_l"]], "trail": "foot_f", "crouch": true, "cancel": true, "chain": ["c_heavy", "c_kick"],
	}
	moves.c_heavy = {
		"anim": [[6, {"base": "crouch", "t": 30.0}], [4, {"t": -30.0, "head": 20.0, "th_f": 172.0, "sh_f": 176.0, "th_b": -4.0, "sh_b": -4.0, "ua_f": -60.0, "fa_f": -30.0, "face": "shout"}],
			[6, {"t": -30.0, "head": 20.0, "th_f": 174.0, "sh_f": 178.0, "th_b": -4.0, "sh_b": -4.0, "ua_f": -60.0, "fa_f": -30.0, "face": "shout"}], [14, "crouch"]],
		"hits": [{"f": [8, 15], "seg": "leg_f", "r": 22.0, "dmg": 90.0, "stun": 20, "bstun": 14, "kb": 3.0, "lift": -14.0, "kd": true, "hs": 10, "spark": "heavy", "sfx": "hit_h"}],
		"sfx": [[5, "swing_h"]], "trail": "foot_f", "crouch": true, "cancel": true,
	}
	moves.c_kick = {
		"anim": [[4, {"base": "crouch", "t": 36.0}], [3, {"base": "crouch", "t": 40.0, "ua_f": 0.0, "fa_f": 0.0, "th_f": 92.0, "sh_f": 92.0, "face": "attack"}], [5, {"base": "crouch", "t": 40.0, "ua_f": 0.0, "fa_f": 0.0, "th_f": 92.0, "sh_f": 92.0}], [12, "crouch"]],
		"hits": [{"f": [6, 12], "seg": "foot_f", "r": 18.0, "dmg": 58.0, "stun": 18, "bstun": 12, "kb": 4.0, "lvl": "low", "kd": true, "lift": -6.0, "hs": 8}],
		"sfx": [[3, "swing_m"]], "trail": "foot_f", "crouch": true,
	}
	moves.j_light = {
		"anim": [[3, {"base": "jump", "th_f": 110.0, "sh_f": 0.0}], [3, {"base": "jump", "th_f": 80.0, "sh_f": 10.0, "face": "attack"}], [10, {"base": "jump", "th_f": 80.0, "sh_f": 10.0}], [6, "jump"]],
		"hits": [{"f": [4, 14], "seg": "foot_f", "pts": [], "r": 20.0, "dmg": 40.0, "stun": 15, "bstun": 10, "kb": 4.0, "lvl": "high", "hs": 6, "sfx": "hit_l"}],
		"sfx": [[2, "swing_l"]], "trail": "foot_f", "air": true,
	}
	moves.j_heavy = {
		"anim": [[6, {"base": "jump", "t": -20.0, "th_f": 170.0, "sh_f": 178.0}], [4, {"base": "jump", "t": 20.0, "th_f": 60.0, "sh_f": 50.0, "face": "shout"}], [10, {"base": "jump", "t": 20.0, "th_f": 50.0, "sh_f": 40.0}], [6, "jump"]],
		"hits": [{"f": [7, 18], "seg": "foot_f", "r": 24.0, "dmg": 95.0, "stun": 20, "bstun": 14, "kb": 6.0, "lvl": "high", "hs": 11, "spark": "heavy", "sfx": "hit_h"}],
		"sfx": [[5, "swing_h"]], "trail": "foot_f", "air": true,
	}
	moves.j_kick = {
		"anim": [[4, {"base": "jump", "th_f": 60.0, "sh_f": 10.0}], [3, {"base": "jump", "t": -16.0, "th_f": 60.0, "sh_f": 58.0, "face": "attack"}], [12, {"base": "jump", "t": -16.0, "th_f": 60.0, "sh_f": 58.0}], [5, "jump"]],
		"hits": [{"f": [6, 18], "seg": "foot_f", "r": 22.0, "dmg": 62.0, "stun": 16, "bstun": 11, "kb": 6.0, "lvl": "high", "hs": 8}],
		"sfx": [[3, "swing_m"]], "trail": "foot_f", "air": true,
	}

	# --- specials
	var dash_kick := {"t": -10.0, "head": 0.0, "th_f": 90.0, "sh_f": 90.0, "th_b": -30.0, "sh_b": -50.0, "ua_f": -60.0, "fa_f": -40.0, "ua_b": -80.0, "fa_b": -50.0, "face": "shout", "fx": "diable"}
	moves.s1 = {
		"title": "Diable Jambe: PREMIER HACHE!",
		"anim": [[8, {"base": "crouch", "rot": -360.0, "fx": "diable"}], [4, dash_kick], [12, dash_kick], [14, "idle"]],
		"hits": [{"f": [10, 22], "seg": "leg_f", "r": 28.0, "dmg": 115.0, "stun": 24, "bstun": 16, "kb": 8.0, "lift": -8.0, "kd": true, "hs": 13, "spark": "fire", "sfx": "hit_h", "chip": 0.12}],
		"vel": [[9, 17.0], [22, 2.0]], "slide": true, "sfx": [[2, "fire"], [9, "swing_h"]], "trail": "foot_f",
	}
	moves.s1_h = {
		"title": "CONCASSÉ!",
		"anim": [[6, {"base": "crouch"}], [10, {"base": "jump", "t": -24.0, "rot": -30.0, "th_f": 176.0, "sh_f": 182.0, "th_b": -10.0, "sh_b": -10.0, "face": "angry"}],
			[6, {"t": 30.0, "rot": 10.0, "th_f": 70.0, "sh_f": 70.0, "th_b": -20.0, "sh_b": -30.0, "face": "shout"}], [16, {"t": 30.0, "th_f": 70.0, "sh_f": 70.0, "th_b": -20.0, "sh_b": -30.0, "face": "shout"}], [10, "crouch"]],
		"hits": [{"f": [17, 36], "seg": "foot_f", "r": 30.0, "dmg": 125.0, "stun": 24, "bstun": 16, "kb": 6.0, "lvl": "high", "kd": true, "hs": 14, "spark": "heavy", "sfx": "hit_h", "chip": 0.1}],
		"vel": [[6, 7.0, -17.0]], "sfx": [[5, "jump"], [16, "swing_h"]], "trail": "foot_f", "shake_at": [[30, 5.0]],
	}
	var spin_a := {"base": "hand", "rot": 180.0, "th_f": 92.0, "sh_f": 92.0, "th_b": -92.0, "sh_b": -92.0, "face": "shout"}
	var spin_b := spin_a.duplicate()
	spin_b.rot = 0.0
	spin_b.th_f = -92.0
	spin_b.sh_f = -92.0
	spin_b.th_b = 92.0
	spin_b.sh_b = 92.0
	spin_b["base"] = "hand"
	moves.s2 = {
		"title": "PARTY TABLE KICK COURSE!",
		"anim": [[6, {"base": "crouch"}], [5, spin_a], [5, spin_b], [5, spin_a], [5, spin_b], [5, spin_a], [5, spin_b], [12, "crouch"]],
		"hits": multi(8, 6, 5, {"seg": "hip", "r": 105.0, "dmg": 20.0, "stun": 16, "bstun": 9, "kb": 3.0, "hs": 4, "sfx": "hit_m", "chip": 0.1}, {"dmg": 40.0, "kd": true, "lift": -9.0, "kb": 9.0, "hs": 11, "sfx": "hit_h", "spark": "heavy"}),
		"vel": [[7, 3.0]], "slide": true, "sfx": [[6, "swing_m"], [16, "swing_m"], [26, "swing_m"]],
	}
	moves.s3 = {
		"title": "ANTI-MANNER KICK COURSE!",
		"anim": [[5, {"base": "crouch"}], [5, {"base": "hand", "th_f": 175.0, "sh_f": 178.0, "th_b": 185.0, "sh_b": 182.0, "rot": 180.0}],
			[8, {"base": "hand", "rot": 180.0, "th_f": 0.0, "sh_f": 0.0, "th_b": 0.0, "sh_b": 0.0, "sl_f": 1.15, "sl_b": 1.15}], [14, "crouch"]],
		"hits": [{"f": [9, 18], "seg": "leg_f", "r": 30.0, "dmg": 95.0, "stun": 20, "bstun": 14, "kb": 2.0, "lift": -17.0, "kd": true, "hs": 12, "spark": "heavy", "sfx": "hit_h"}],
		"invuln": [1, 11], "sfx": [[6, "swing_h"]], "trail": "foot_f",
	}
	moves["super"] = {
		"title": "Diable Jambe: HELL MEMORIES!",
		"super": true,
		"anim": [[18, {"t": -6.0, "head": -10.0, "th_f": 100.0, "sh_f": 20.0, "ua_f": -20.0, "fa_f": 20.0, "face": "angry", "fx": "diable"}],
			[6, {"base": "crouch", "rot": -360.0, "fx": "diable"}], [16, dash_kick], [8, {"t": -30.0, "head": 16.0, "th_f": 140.0, "sh_f": 150.0, "th_b": -6.0, "sh_b": -6.0, "face": "shout", "fx": "diable"}],
			[14, {"t": -30.0, "head": 16.0, "th_f": 140.0, "sh_f": 150.0, "th_b": -6.0, "sh_b": -6.0, "face": "shout", "fx": "diable"}], [14, "idle"]],
		"hits": multi(26, 5, 3, {"seg": "leg_f", "r": 34.0, "dmg": 22.0, "stun": 30, "bstun": 10, "kb": 1.0, "hs": 3, "spark": "fire", "sfx": "hit_m", "chip": 0.15}),
		"proj": [[50, {"type": "entei", "pos": [110, -170], "vel": [5, 0], "r": 90.0, "size": 1.0, "life": 40, "hp": 6, "hits": 4, "every": 5,
			"hit": {"dmg": 45.0, "stun": 26, "bstun": 12, "kb": 5.0, "lift": -10.0, "kd": true, "hs": 8, "spark": "fire", "sfx": "hit_h", "chip": 0.2}}]],
		"vel": [[25, 15.0], [42, 1.0]], "slide": true, "invuln": [1, 25], "fx": [[50, "fire_burst", [120, -170]]],
		"sfx": [[2, "fire_big"], [25, "swing_h"], [49, "fire_big"]], "trail": "foot_f", "shake_at": [[50, 10.0]],
	}


func draw_torso_extra(cv: CanvasItem, _J: Dictionary, _p: Dictionary, st: Dictionary, L: float, ch: float) -> void:
	# blue shirt V, black tie and jacket lapel
	var shirt := PackedVector2Array([Vector2(8 * ch, -L * 0.45), Vector2(19 * ch, -L * 0.7), Vector2(15 * ch, -L - 3), Vector2(4 * ch, -L - 1)])
	shape(cv, shirt, Color("4f7fcf"), st, false, 1.8)
	var tie := PackedVector2Array([Vector2(13 * ch, -L + 2), Vector2(17 * ch, -L * 0.62), Vector2(14 * ch, -L * 0.5), Vector2(11 * ch, -L * 0.62)])
	shape(cv, tie, Color("101014"), st, false, 1.4)
	cv.draw_line(Vector2(5 * ch, -L), Vector2(9 * ch, -L * 0.42), fc(col.top, st).lightened(0.25), 2.0, true)
	for i in 2:
		cv.draw_circle(Vector2(9 * ch, -L * (0.3 + i * 0.1)), 2.0, fc(Color("c9a03a"), st))


func draw_hair(cv: CanvasItem, R: float, _p: Dictionary, st: Dictionary) -> void:
	# sleek blond hair, swept over one side of the face
	var back := PackedVector2Array()
	for i in 13:
		var a := deg_to_rad(lerpf(120.0, 330.0, float(i) / 12.0))
		var r := R * 1.08 + (sin(i * 1.7) * R * 0.05)
		back.append(Vector2(cos(a) * r, sin(a) * r))
	back.append(Vector2(R * 0.4, -R * 0.5))
	back.append(Vector2(-R * 0.6, R * 0.55))
	shape(cv, back, col.hair, st, true, 2.0)
	var bang := PackedVector2Array([Vector2(R * 0.05, -R * 1.0), Vector2(R * 0.85, -R * 0.75), Vector2(R * 1.05, -R * 0.2), Vector2(R * 0.82, R * 0.12), Vector2(R * 0.7, -R * 0.2), Vector2(R * 0.5, -R * 0.12), Vector2(R * 0.4, -R * 0.5)])
	shape(cv, bang, col.hair, st, true, 2.0)


func draw_brow(cv: CanvasItem, eye: Vector2, R: float, tilt: float, st: Dictionary) -> void:
	# the famous curly eyebrow
	var c := eye + Vector2(-R * 0.18, -R * 0.36 - tilt * 0.3)
	cv.draw_arc(c, R * 0.07, 0.0, TAU * 0.85, 8, fc(col.hair, st).darkened(0.3), 2.2, true)
	cv.draw_line(c + Vector2(R * 0.07, 0), eye + Vector2(R * 0.26, -R * 0.34 + tilt), fc(col.hair, st).darkened(0.3), 2.6, true)


func draw_face_extra(cv: CanvasItem, R: float, p: Dictionary, st: Dictionary) -> void:
	# goatee and cigarette
	cv.draw_line(Vector2(R * 0.7, R * 0.9), Vector2(R * 0.82, R * 1.08), fc(col.hair, st).darkened(0.25), 3.0, true)
	if p.get("face", "") in ["shout", "attack", "hurt", "ko"]:
		return
	var m := Vector2(R * 0.82, R * 0.55)
	var tip := m + Vector2(R * 0.55, -R * 0.06)
	cv.draw_line(m, tip, Color(0.96, 0.95, 0.9), 4.0, true)
	cv.draw_line(tip - Vector2(R * 0.08, 0), tip, Color(1.0, 0.45, 0.1), 4.0, true)


func draw_front_fx(cv: CanvasItem, J: Dictionary, p: Dictionary, st: Dictionary) -> void:
	if p.get("fx", "") != "diable":
		return
	var tt: float = st.get("time", 0.0)
	var a: Vector2 = J.knee_f
	var b: Vector2 = J.toe_f
	for i in 6:
		var u := float(i) / 5.0
		var c := a.lerp(b, u)
		var r := 16.0 + 8.0 * sin(tt * 30.0 + i)
		cv.draw_circle(c, r + 8.0, Color(1.0, 0.3, 0.0, 0.35))
		cv.draw_circle(c, r, Color(1.0, 0.65, 0.1, 0.55))
		cv.draw_circle(c, r * 0.5, Color(1.0, 0.95, 0.6, 0.7))


func update_fx(f, fx) -> void:
	var p: Dictionary = f.pose
	var fxk := String(p.get("fx", ""))
	if fxk == "diable" and Engine.get_physics_frames() % 2 == 0:
		var pos: Vector2 = f.world_point(f.J.knee_f.lerp(f.J.toe_f, randf()))
		fx.flame(pos, Vector2(randf_range(-1, 1), randf_range(-3, -1)), randf_range(8, 16), 18)
	elif String(p.get("face", "")) in ["normal", "grin", "closed", "angry"] and Engine.get_physics_frames() % 9 == 0:
		# cigarette smoke
		var R: float = dims.head
		var tip: Vector2 = f.J.head + Vector2(R * 1.3, R * 0.5).rotated(f.J.head_ang)
		fx.smoke(f.world_point(tip), Color(0.9, 0.9, 0.95, 0.35), 0.5)
