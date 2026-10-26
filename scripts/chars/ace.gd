extends CharData
## Portgas D. Ace: Flame-Flame fruit. Strong fire projectiles and zoning.


func setup() -> void:
	id = "ace"
	display_name = "ACE"
	epithet = "Fire Fist"
	quote = "Don't hold back. I won't."
	accent = Color("f07a1a")
	trail_color = Color(1.0, 0.6, 0.2)
	ai_zoner = true
	dims.thigh = 58.0
	dims.shin = 58.0
	dims.torso = 80.0
	dims.head = 23.0
	dims.ua = 42.0
	dims.fa = 40.0
	dims.chest = 1.3
	dims.limb = 1.04
	col.skin = Color("e7b07e")
	col.hair = Color("1a1414")
	col.pants = Color("2a2522")
	col.cuff_c = Color("3a3330")
	col.shoes = Color("1a1412")
	style = {"top": "none", "sleeves": "none", "pants": "knee", "feet": "boot", "cuff": false}
	walk_speed = 4.3
	back_speed = 3.4

	poses.idle = {"t": 10.0, "head": -10.0, "ua_f": 30.0, "fa_f": 120.0, "ua_b": 6.0, "fa_b": 60.0, "th_f": 30.0, "sh_f": -4.0, "th_b": -22.0, "sh_b": -26.0, "fx": "ember"}
	poses.idle_b = {"hy": 3.0, "t": 12.0, "head": -11.0, "ua_f": 34.0, "fa_f": 116.0, "ua_b": 8.0, "fa_b": 56.0, "th_f": 33.0, "sh_f": -8.0, "th_b": -23.0, "sh_b": -24.0, "fx": "ember"}
	poses.win = {"t": 0.0, "head": -12.0, "ua_f": 175.0, "fa_f": 175.0, "ua_b": -10.0, "fa_b": 20.0, "th_f": 12.0, "sh_f": 2.0, "th_b": -10.0, "sh_b": -4.0, "face": "grin", "fx": "fire_f"}
	poses.intro = {"t": 2.0, "head": -16.0, "ua_f": 150.0, "fa_f": 30.0, "ua_b": 6.0, "fa_b": 10.0, "th_f": 10.0, "sh_f": 0.0, "th_b": -10.0, "sh_b": -2.0, "face": "closed"}
	poses.raise = {"t": -6.0, "head": -26.0, "ua_f": 175.0, "fa_f": 178.0, "ua_b": 30.0, "fa_b": 60.0, "th_f": 26.0, "sh_f": 0.0, "th_b": -24.0, "sh_b": -24.0, "face": "shout", "fx": "sun"}

	var jab := {"t": 16.0, "ua_f": 90.0, "fa_f": 90.0, "ua_b": -10.0, "fa_b": 50.0, "face": "attack", "fx": "fire_f"}
	moves.light = {
		"anim": [[3, {"t": 6.0, "ua_f": 60.0, "fa_f": 100.0}], [3, jab], [3, jab], [9, "idle"]],
		"hits": [{"f": [5, 9], "seg": "hand_f", "r": 18.0, "dmg": 44.0, "stun": 14, "bstun": 9, "kb": 4.5, "hs": 6, "spark": "fire", "sfx": "hit_l"}],
		"sfx": [[2, "swing_l"]], "trail": "hand_f", "cancel": true, "chain": ["heavy", "kick"],
	}
	moves.heavy = {
		"anim": [[10, {"t": -10.0, "ua_f": -60.0, "fa_f": 60.0, "ua_b": 50.0, "fa_b": 130.0, "face": "angry", "fx": "fire_f"}],
			[3, {"t": 26.0, "ua_f": 95.0, "fa_f": 100.0, "ua_b": -30.0, "fa_b": 20.0, "face": "shout", "fx": "fire_f"}], [5, {"t": 26.0, "ua_f": 95.0, "fa_f": 100.0, "ua_b": -30.0, "fa_b": 20.0, "face": "shout", "fx": "fire_f"}], [14, "idle"]],
		"hits": [{"f": [11, 17], "seg": "hand_f", "r": 30.0, "dmg": 105.0, "stun": 22, "bstun": 16, "kb": 9.0, "hs": 12, "spark": "fire", "sfx": "hit_h"}],
		"sfx": [[9, "swing_h"], [10, "fire"]], "trail": "hand_f", "cancel": true, "fx": [[12, "fire_trail", [90, -150]]],
	}
	moves.kick = {
		"anim": [[5, {"t": -8.0, "th_f": 70.0, "sh_f": 10.0}], [3, {"t": -20.0, "head": 10.0, "th_f": 100.0, "sh_f": 96.0, "th_b": -12.0, "sh_b": -14.0, "face": "attack"}], [4, {"t": -20.0, "head": 10.0, "th_f": 100.0, "sh_f": 96.0, "th_b": -12.0, "sh_b": -14.0}], [11, "idle"]],
		"hits": [{"f": [7, 12], "seg": "foot_f", "r": 20.0, "dmg": 62.0, "stun": 17, "bstun": 12, "kb": 7.0, "hs": 8}],
		"sfx": [[4, "swing_m"]], "trail": "foot_f", "cancel": true,
	}
	moves.c_light = {
		"anim": [[3, {"base": "crouch", "ua_f": 70.0, "fa_f": 110.0}], [3, {"base": "crouch", "ua_f": 88.0, "fa_f": 88.0, "face": "attack"}], [3, {"base": "crouch", "ua_f": 88.0, "fa_f": 88.0}], [8, "crouch"]],
		"hits": [{"f": [5, 9], "seg": "hand_f", "r": 17.0, "dmg": 32.0, "stun": 13, "bstun": 8, "kb": 4.0, "lvl": "low", "hs": 5, "sfx": "hit_l"}],
		"sfx": [[2, "swing_l"]], "trail": "hand_f", "crouch": true, "cancel": true, "chain": ["c_heavy", "c_kick"],
	}
	moves.c_heavy = {
		"anim": [[6, {"base": "crouch", "ua_f": -10.0, "fa_f": 60.0, "fx": "fire_f"}], [4, {"t": -8.0, "head": -26.0, "ua_f": 160.0, "fa_f": 172.0, "th_f": 20.0, "sh_f": 0.0, "th_b": -14.0, "sh_b": -10.0, "face": "shout", "fx": "fire_f"}],
			[6, {"t": -8.0, "head": -26.0, "ua_f": 165.0, "fa_f": 175.0, "th_f": 20.0, "sh_f": 0.0, "th_b": -14.0, "sh_b": -10.0, "face": "shout", "fx": "fire_f"}], [14, "crouch"]],
		"hits": [{"f": [8, 15], "seg": "arm_f", "r": 28.0, "dmg": 90.0, "stun": 20, "bstun": 14, "kb": 3.0, "lift": -14.0, "kd": true, "hs": 10, "spark": "fire", "sfx": "hit_h"}],
		"sfx": [[5, "fire"]], "trail": "hand_f", "crouch": true, "cancel": true,
	}
	moves.c_kick = {
		"anim": [[5, {"base": "crouch", "t": 34.0}], [3, {"base": "crouch", "t": 36.0, "th_f": 92.0, "sh_f": 92.0, "face": "attack"}], [5, {"base": "crouch", "t": 36.0, "th_f": 92.0, "sh_f": 92.0}], [12, "crouch"]],
		"hits": [{"f": [7, 13], "seg": "foot_f", "r": 18.0, "dmg": 58.0, "stun": 18, "bstun": 12, "kb": 4.0, "lvl": "low", "kd": true, "lift": -6.0, "hs": 8}],
		"sfx": [[4, "swing_m"]], "trail": "foot_f", "crouch": true,
	}
	moves.j_light = {
		"anim": [[3, {"base": "jump", "ua_f": 60.0, "fa_f": 100.0}], [3, {"base": "jump", "ua_f": 62.0, "fa_f": 62.0, "face": "attack"}], [10, {"base": "jump", "ua_f": 62.0, "fa_f": 62.0}], [6, "jump"]],
		"hits": [{"f": [5, 14], "seg": "hand_f", "r": 18.0, "dmg": 42.0, "stun": 15, "bstun": 10, "kb": 4.0, "lvl": "high", "hs": 6, "sfx": "hit_l"}],
		"sfx": [[2, "swing_l"]], "trail": "hand_f", "air": true,
	}
	moves.j_heavy = {
		"anim": [[6, {"base": "jump", "ua_f": 175.0, "fa_f": 175.0, "fx": "fire_f"}], [3, {"base": "jump", "t": 30.0, "ua_f": 55.0, "fa_f": 40.0, "face": "shout", "fx": "fire_f"}], [10, {"base": "jump", "t": 30.0, "ua_f": 50.0, "fa_f": 35.0, "fx": "fire_f"}], [6, "jump"]],
		"hits": [{"f": [8, 18], "seg": "hand_f", "r": 28.0, "dmg": 92.0, "stun": 20, "bstun": 14, "kb": 6.0, "lvl": "high", "hs": 11, "spark": "fire", "sfx": "hit_h"}],
		"sfx": [[6, "fire"]], "trail": "hand_f", "air": true,
	}
	moves.j_kick = {
		"anim": [[4, {"base": "jump", "th_f": 60.0, "sh_f": 20.0}], [3, {"base": "jump", "t": -10.0, "th_f": 72.0, "sh_f": 66.0, "face": "attack"}], [12, {"base": "jump", "t": -10.0, "th_f": 72.0, "sh_f": 66.0}], [5, "jump"]],
		"hits": [{"f": [6, 18], "seg": "foot_f", "r": 20.0, "dmg": 58.0, "stun": 16, "bstun": 11, "kb": 5.0, "lvl": "high", "hs": 8}],
		"sfx": [[3, "swing_m"]], "trail": "foot_f", "air": true,
	}

	# --- specials
	var throw := {"t": 22.0, "head": -10.0, "ua_f": 92.0, "fa_f": 92.0, "ua_b": -30.0, "fa_b": 10.0, "th_f": 46.0, "face": "shout", "fx": "fire_f"}
	moves.s1 = {
		"title": "HIKEN!",
		"anim": [[11, {"t": -14.0, "ua_f": -70.0, "fa_f": 40.0, "ua_b": 50.0, "fa_b": 120.0, "face": "angry", "fx": "fire_f"}], [4, throw], [10, throw], [12, "idle"]],
		"proj": [[13, {"type": "fire_fist", "pos": [110, -158], "vel": [11, 0], "r": 52.0, "life": 90,
			"hit": {"dmg": 105.0, "stun": 22, "bstun": 16, "kb": 8.0, "hs": 10, "spark": "fire", "sfx": "hit_h", "chip": 0.12}}]],
		"sfx": [[10, "fire_big"]], "fx": [[13, "fire_burst", [90, -158]]],
	}
	moves.s1_h = {
		"title": "JUJIKA!",
		"anim": [[14, {"t": 0.0, "ua_f": 120.0, "fa_f": 160.0, "ua_b": 110.0, "fa_b": 150.0, "face": "angry", "fx": "fire_f"}], [4, {"t": 16.0, "ua_f": 95.0, "fa_f": 120.0, "ua_b": 95.0, "fa_b": 60.0, "face": "shout", "fx": "fire_f"}],
			[10, {"t": 16.0, "ua_f": 95.0, "fa_f": 120.0, "ua_b": 95.0, "fa_b": 60.0, "face": "shout"}], [12, "idle"]],
		"proj": [[16, {"type": "cross", "pos": [100, -160], "vel": [16, 0], "r": 46.0, "life": 70, "hp": 2,
			"hit": {"dmg": 95.0, "stun": 22, "bstun": 16, "kb": 10.0, "kd": true, "lift": -8.0, "hs": 11, "spark": "fire", "sfx": "hit_h", "chip": 0.12}}]],
		"sfx": [[14, "fire_big"]],
	}
	var ffly := {"type": "firefly", "r": 16.0, "life": 150, "hit": {"dmg": 22.0, "stun": 14, "bstun": 8, "kb": 2.0, "hs": 4, "spark": "fire", "sfx": "fire", "chip": 0.2}}
	var flies := []
	var i := 0
	for v in [[3.2, -1.2], [4.0, 0.6], [2.6, -2.2], [4.6, -0.4], [3.4, 1.4], [2.2, -0.8]]:
		var d := ffly.duplicate(true)
		d["vel"] = v
		d["pos"] = [60 + i * 8, -150 - (i % 3) * 30]
		flies.append([14 + i * 2, d])
		i += 1
	moves.s2 = {
		"title": "HOTARUBI!",
		"anim": [[12, {"t": 4.0, "ua_f": 60.0, "fa_f": 150.0, "ua_b": 40.0, "fa_b": 140.0, "face": "closed", "fx": "fire_f"}], [14, {"t": 10.0, "ua_f": 100.0, "fa_f": 100.0, "ua_b": 70.0, "fa_b": 70.0, "face": "grin"}], [12, "idle"]],
		"proj": flies, "sfx": [[12, "fire"], [18, "fire"]],
	}
	moves.s3 = {
		"title": "ENKAI: HIBASHIRA!",
		"anim": [[5, {"base": "crouch", "fx": "fire_f"}], [6, {"t": -4.0, "head": -20.0, "ua_f": 175.0, "fa_f": 178.0, "ua_b": 170.0, "fa_b": 176.0, "th_f": 10.0, "sh_f": 0.0, "th_b": -10.0, "sh_b": -6.0, "face": "shout", "fx": "pillar"}],
			[18, {"t": -4.0, "head": -20.0, "ua_f": 176.0, "fa_f": 179.0, "ua_b": 172.0, "fa_b": 177.0, "th_f": 10.0, "sh_f": 0.0, "th_b": -10.0, "sh_b": -6.0, "face": "shout", "fx": "pillar"}], [14, "idle"]],
		"hits": multi(7, 4, 5, {"seg": "pts", "pts": [[30, -320], [30, -40]], "r": 70.0, "dmg": 26.0, "stun": 20, "bstun": 9, "kb": 2.0, "lift": -11.0, "kd": true, "hs": 4, "spark": "fire", "sfx": "fire", "chip": 0.15},
			{"dmg": 40.0, "lift": -14.0, "kb": 6.0, "hs": 10, "sfx": "hit_h"}),
		"invuln": [1, 12], "sfx": [[6, "fire_big"]],
	}
	moves["super"] = {
		"title": "DAI ENKAI: ENTEI!",
		"super": true,
		"anim": [[34, "raise"], [10, {"base": "raise", "t": -16.0}], [6, {"t": 26.0, "head": -10.0, "ua_f": 100.0, "fa_f": 95.0, "ua_b": -30.0, "fa_b": 10.0, "th_f": 46.0, "face": "shout", "fx": "fire_f"}], [14, throw], [14, "idle"]],
		"proj": [[46, {"type": "entei", "pos": [140, -260], "vel": [6.5, 1.0], "acc": [0.12, 0], "r": 115.0, "size": 1.35, "life": 120, "hp": 8, "hits": 5, "every": 6,
			"hit": {"dmg": 54.0, "stun": 26, "bstun": 12, "kb": 4.0, "lift": -6.0, "kd": true, "hs": 8, "spark": "fire", "sfx": "hit_h", "chip": 0.2}}]],
		"invuln": [1, 30], "sfx": [[2, "fire_big"], [20, "aura"], [45, "fire_big"]], "shake_at": [[46, 8.0]],
	}


func draw_torso_extra(cv: CanvasItem, _J: Dictionary, _p: Dictionary, st: Dictionary, L: float, ch: float) -> void:
	# red bead necklace
	for i in 7:
		var a := deg_to_rad(lerpf(-20.0, 100.0, float(i) / 6.0))
		var c := Vector2(2 * ch, -L + 4) + Vector2(cos(a) * 14.0 * ch, sin(a) * 18.0)
		cv.draw_circle(c, 3.6, fc(Color("c4202a"), st))
		cv.draw_arc(c, 3.6, 0, TAU, 8, OUTLINE, 1.0, true)
	# belt with the big buckle
	var belt := PackedVector2Array([Vector2(-17 * ch, 6), Vector2(18 * ch, 6), Vector2(17 * ch, -6), Vector2(-17 * ch, -5)])
	shape(cv, belt, Color("6b3a1c"), st, false, 1.8)
	shape(cv, PackedVector2Array([Vector2(8 * ch, 8), Vector2(18 * ch, 8), Vector2(18 * ch, -8), Vector2(8 * ch, -8)]), Color("e0a83a"), st, false, 1.6)


func draw_arm_extra(cv: CanvasItem, J: Dictionary, _p: Dictionary, s: String, st: Dictionary) -> void:
	if s == "b":
		# ASCE tattoo hint on the upper arm
		var a: Vector2 = J.shoulder.lerp(J.elbow_b, 0.55)
		cv.draw_rect(Rect2(a - Vector2(7, 3), Vector2(14, 6)), fc(Color("3a2d5a"), st))
	else:
		# log pose bracelet
		var w: Vector2 = J.elbow_f.lerp(J.hand_f, 0.75)
		cv.draw_circle(w, 7.5, fc(Color("e0a83a"), st))
		cv.draw_arc(w, 7.5, 0, TAU, 10, OUTLINE, 1.4, true)


func draw_face_extra(cv: CanvasItem, R: float, _p: Dictionary, st: Dictionary) -> void:
	var c := fc(Color("b87a52"), st)
	for v in [Vector2(0.02, 0.4), Vector2(0.12, 0.46), Vector2(0.22, 0.4), Vector2(0.1, 0.52), Vector2(0.64, 0.4), Vector2(0.72, 0.46)]:
		cv.draw_circle(v * R, 1.5, c)


func draw_hair(cv: CanvasItem, R: float, _p: Dictionary, st: Dictionary) -> void:
	spikes(cv, R * 1.0, 100.0, 345.0, 8, R * 0.32, col.hair, st, 0.3, Vector2(-R * 0.05, -R * 0.05), 5, -14.0)
	var b := local_pts(Vector2.ZERO, Vector2.RIGHT, Vector2.DOWN, R, [[-0.2, -1.0], [0.6, -0.95], [0.98, -0.6], [0.98, -0.3], [0.82, -0.44], [0.7, -0.26], [0.58, -0.5], [0.44, -0.3], [0.32, -0.54], [0.14, -0.36], [0.02, -0.6], [-0.22, -0.56]])
	shape(cv, b, col.hair, st, true, 2.2)


func draw_hat(cv: CanvasItem, R: float, _p: Dictionary, st: Dictionary) -> void:
	var Rh := R * 1.3
	var orange := Color("e8862a")
	# cowboy hat: curled brim and pinched crown, worn tilted back
	var brim := PackedVector2Array()
	for i in 20:
		var a := TAU * float(i) / 20.0
		var y := sin(a) * Rh * 0.28 - absf(cos(a)) * Rh * 0.18
		brim.append(Vector2(cos(a) * Rh * 1.45 - Rh * 0.2, y - Rh * 0.6))
	shape(cv, brim, orange, st)
	var crown := PackedVector2Array([Vector2(-Rh * 0.95, -Rh * 0.75), Vector2(Rh * 0.6, -Rh * 0.75), Vector2(Rh * 0.55, -Rh * 1.25), Vector2(Rh * 0.2, -Rh * 1.45), Vector2(-Rh * 0.15, -Rh * 1.3), Vector2(-Rh * 0.55, -Rh * 1.48), Vector2(-Rh * 0.9, -Rh * 1.25)])
	shape(cv, crown, orange, st)
	shape(cv, PackedVector2Array([Vector2(-Rh * 0.95, -Rh * 0.76), Vector2(Rh * 0.6, -Rh * 0.76), Vector2(Rh * 0.58, -Rh * 0.92), Vector2(-Rh * 0.93, -Rh * 0.92)]), Color("2a1a14"), st, false, 1.6)
	# smiley and sad badges
	cv.draw_circle(Vector2(Rh * 0.15, -Rh * 1.08), Rh * 0.15, fc(Color("3f6fc8"), st))
	cv.draw_arc(Vector2(Rh * 0.15, -Rh * 1.06), Rh * 0.08, 0.3, PI - 0.3, 6, Color.WHITE, 1.4, true)
	cv.draw_circle(Vector2(-Rh * 0.4, -Rh * 1.08), Rh * 0.15, fc(Color("c43a3a"), st))
	cv.draw_arc(Vector2(-Rh * 0.4, -Rh * 1.0), Rh * 0.08, PI + 0.3, TAU - 0.3, 6, Color.WHITE, 1.4, true)


func draw_front_fx(cv: CanvasItem, J: Dictionary, p: Dictionary, st: Dictionary) -> void:
	var fxk: String = p.get("fx", "")
	var tt: float = st.get("time", 0.0)
	if fxk == "fire_f":
		for i in 5:
			var c: Vector2 = J.elbow_f.lerp(J.hand_f, 0.4 + i * 0.15)
			var r := 12.0 + 6.0 * sin(tt * 28.0 + i * 1.3)
			cv.draw_circle(c, r + 7.0, Color(1.0, 0.3, 0.0, 0.3))
			cv.draw_circle(c, r, Color(1.0, 0.6, 0.1, 0.5))
	elif fxk == "sun":
		var c: Vector2 = J.hand_f + Vector2(0, -70)
		var grow := clampf(fmod(tt, 100.0), 0.0, 1.0)
		var r := 70.0 + 6.0 * sin(tt * 9.0)
		cv.draw_circle(c, r * 1.35, Color(1.0, 0.25, 0.0, 0.25 * grow))
		cv.draw_circle(c, r, Color(1.0, 0.5, 0.05, 0.6 * grow))
		cv.draw_circle(c, r * 0.65, Color(1.0, 0.85, 0.35, 0.85 * grow))
	elif fxk == "pillar":
		var base: Vector2 = J.hip
		for i in 8:
			var y := -float(i) * 45.0
			var w := 70.0 - i * 4.0 + 10.0 * sin(tt * 20.0 + i)
			cv.draw_circle(base + Vector2(sin(tt * 13.0 + i) * 12.0, y + 60.0), w, Color(1.0, 0.45 + i * 0.04, 0.05, 0.35))


func update_fx(f, fx) -> void:
	var fxk := String(f.pose.get("fx", ""))
	var frame := Engine.get_physics_frames()
	match fxk:
		"fire_f":
			if frame % 2 == 0:
				fx.flame(f.world_point(f.J.hand_f), Vector2(randf_range(-1, 1), randf_range(-3, -1)), randf_range(8, 15), 18)
		"ember":
			if frame % 14 == 0:
				fx.flame(f.world_point(f.J.hand_f), Vector2(randf_range(-0.4, 0.4), -1.2), 5.0, 22)
		"pillar":
			for k in 3:
				fx.flame(f.world_point(f.J.hip + Vector2(randf_range(-60, 60), randf_range(-40, 40))), Vector2(randf_range(-1, 1), randf_range(-12, -6)), randf_range(14, 26), 26)
		"sun":
			if frame % 2 == 0:
				fx.flame(f.world_point(f.J.hand_f + Vector2(randf_range(-80, 80), -90 + randf_range(-80, 80))), Vector2(0, -2), randf_range(10, 22), 20)
