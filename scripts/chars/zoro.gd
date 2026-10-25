extends CharData
## Roronoa Zoro: three sword style. Slow, huge sword damage, wind blade projectiles.


func setup() -> void:
	id = "zoro"
	display_name = "ZORO"
	epithet = "Pirate Hunter"
	quote = "Nothing happened."
	accent = Color("3f9a46")
	trail_color = Color(0.85, 0.97, 1.0)
	has_swords = true
	ai_zoner = true
	dims.thigh = 58.0
	dims.shin = 60.0
	dims.torso = 82.0
	dims.head = 26.0
	dims.ua = 43.0
	dims.fa = 41.0
	dims.chest = 1.25
	dims.limb = 1.1
	dims.sword = 124.0
	col.skin = Color("e2b083")
	col.hair = Color("5fb550")
	col.top = Color("f1f0ea")
	col.sleeve = Color("f1f0ea")
	col.pants = Color("26262e")
	col.shoes = Color("17171b")
	style = {"top": "shirt", "sleeves": "short", "pants": "long", "feet": "boot", "cuff": false}
	walk_speed = 3.9
	back_speed = 3.2
	jump_vy = -19.0
	max_hp = 1050.0

	poses.idle = {"t": 14.0, "head": -10.0, "ua_f": 42.0, "fa_f": 105.0, "sa_f": 140.0, "ua_b": 22.0, "fa_b": 85.0, "sa_b": 115.0, "th_f": 38.0, "sh_f": -6.0, "th_b": -30.0, "sh_b": -32.0, "face": "angry"}
	poses.idle_b = {"hy": 3.0, "t": 16.0, "head": -11.0, "ua_f": 44.0, "fa_f": 100.0, "sa_f": 136.0, "ua_b": 25.0, "fa_b": 82.0, "sa_b": 112.0, "th_f": 41.0, "sh_f": -9.0, "th_b": -31.0, "sh_b": -30.0, "face": "angry"}
	poses.walk1 = {"t": 14.0, "th_f": 44.0, "sh_f": 4.0, "th_b": -34.0, "sh_b": -34.0}
	poses.walk2 = {"t": 14.0, "th_f": 20.0, "sh_f": -30.0, "th_b": -14.0, "sh_b": -20.0, "hy": -3.0}
	poses.guard = {"t": 0.0, "head": 4.0, "ua_f": 60.0, "fa_f": 140.0, "sa_f": 190.0, "ua_b": 50.0, "fa_b": 130.0, "sa_b": 182.0, "th_f": 30.0, "sh_f": 6.0, "th_b": -26.0, "sh_b": -26.0, "face": "angry"}
	poses.guard_low = {"base": "crouch", "ua_f": 70.0, "fa_f": 120.0, "sa_f": 175.0, "ua_b": 60.0, "fa_b": 120.0, "sa_b": 170.0, "face": "angry"}
	poses.win = {"t": 2.0, "head": -4.0, "ua_f": 20.0, "fa_f": 60.0, "sa_f": 0.0, "ua_b": -10.0, "fa_b": 20.0, "sa_b": -20.0, "th_f": 14.0, "sh_f": 2.0, "th_b": -12.0, "sh_b": -6.0, "face": "closed"}
	poses.intro = {"t": 0.0, "head": -2.0, "ua_f": 100.0, "fa_f": 170.0, "sa_f": 260.0, "ua_b": 10.0, "fa_b": 30.0, "sa_b": 0.0, "th_f": 10.0, "sh_f": 0.0, "th_b": -10.0, "sh_b": -4.0, "face": "closed"}
	poses.oni = {"base": "crouch", "t": 36.0, "head": -30.0, "ua_f": 60.0, "fa_f": 40.0, "sa_f": 150.0, "ua_b": 70.0, "fa_b": 50.0, "sa_b": 30.0, "face": "angry"}
	poses.oni_end = {"t": 22.0, "head": -24.0, "ua_f": 100.0, "fa_f": 110.0, "sa_f": 100.0, "ua_b": -100.0, "fa_b": -110.0, "sa_b": -100.0, "th_f": 70.0, "sh_f": -8.0, "th_b": -50.0, "sh_b": -70.0, "face": "angry"}
	poses.ashura = {"t": 4.0, "head": -6.0, "ua_f": 70.0, "fa_f": 150.0, "sa_f": 200.0, "ua_b": 60.0, "fa_b": 30.0, "sa_b": 10.0, "th_f": 40.0, "sh_f": -4.0, "th_b": -34.0, "sh_b": -34.0, "face": "angry", "fx": "ashura"}

	var raise := {"t": -4.0, "ua_f": 150.0, "fa_f": 190.0, "sa_f": 230.0, "ua_b": 140.0, "fa_b": 180.0, "sa_b": 220.0, "face": "angry"}
	var chop := {"t": 26.0, "head": -20.0, "ua_f": 85.0, "fa_f": 60.0, "sa_f": 40.0, "ua_b": 75.0, "fa_b": 55.0, "sa_b": 50.0, "th_f": 50.0, "sh_f": -4.0, "face": "shout"}

	moves.light = {
		"anim": [[4, {"t": 4.0, "ua_f": 110.0, "fa_f": 170.0, "sa_f": 210.0}], [3, {"t": 20.0, "ua_f": 75.0, "fa_f": 70.0, "sa_f": 60.0, "face": "attack"}], [2, {"t": 20.0, "ua_f": 72.0, "fa_f": 64.0, "sa_f": 50.0, "face": "attack"}], [10, "idle"]],
		"hits": [{"f": [5, 9], "seg": "sword_f", "r": 16.0, "dmg": 52.0, "stun": 15, "bstun": 10, "kb": 5.0, "hs": 7, "spark": "slash", "sfx": "slash_l"}],
		"sfx": [[3, "swing_l"]], "trail": "sword_f", "cancel": true, "chain": ["heavy", "kick"],
	}
	moves.heavy = {
		"title": "Nitoryu: RASHOMON!",
		"anim": [[13, raise], [4, chop], [6, chop], [18, "idle"]],
		"hits": [{"f": [14, 21], "seg": "sword_f", "r": 22.0, "dmg": 140.0, "stun": 26, "bstun": 18, "kb": 9.0, "hs": 14, "spark": "slash", "sfx": "slash_h"},
			{"f": [16, 22], "seg": "sword_b", "r": 20.0, "dmg": 25.0, "stun": 26, "bstun": 18, "kb": 6.0, "hs": 6, "spark": "slash", "sfx": "slash_l"}],
		"sfx": [[12, "swing_h"]], "trail": "sword_f", "zoom": true, "cancel": true,
	}
	moves.kick = {
		"anim": [[5, {"t": -6.0, "th_f": 80.0, "sh_f": 10.0, "th_b": -16.0}], [3, {"t": -14.0, "th_f": 96.0, "sh_f": 92.0, "th_b": -14.0, "sh_b": -16.0, "face": "attack"}], [4, {"t": -14.0, "th_f": 96.0, "sh_f": 92.0, "th_b": -14.0, "sh_b": -16.0, "face": "attack"}], [12, "idle"]],
		"hits": [{"f": [7, 12], "seg": "foot_f", "r": 20.0, "dmg": 55.0, "stun": 17, "bstun": 12, "kb": 7.0, "hs": 8}],
		"sfx": [[4, "swing_m"]], "trail": "foot_f", "cancel": true,
	}
	moves.c_light = {
		"anim": [[4, {"base": "crouch", "ua_f": 80.0, "fa_f": 120.0, "sa_f": 120.0}], [3, {"base": "crouch", "t": 30.0, "ua_f": 80.0, "fa_f": 70.0, "sa_f": 35.0, "face": "attack"}], [3, {"base": "crouch", "t": 30.0, "ua_f": 80.0, "fa_f": 65.0, "sa_f": 28.0}], [10, "crouch"]],
		"hits": [{"f": [5, 9], "seg": "sword_f", "r": 15.0, "dmg": 40.0, "stun": 14, "bstun": 9, "kb": 4.0, "hs": 6, "lvl": "low", "spark": "slash", "sfx": "slash_l"}],
		"sfx": [[3, "swing_l"]], "trail": "sword_f", "crouch": true, "cancel": true, "chain": ["c_heavy", "c_kick"],
	}
	moves.c_heavy = {
		"anim": [[7, {"base": "crouch", "t": 34.0, "ua_f": 50.0, "fa_f": 40.0, "sa_f": 40.0}], [4, {"t": -10.0, "head": -26.0, "ua_f": 150.0, "fa_f": 175.0, "sa_f": 190.0, "th_f": 20.0, "sh_f": 0.0, "th_b": -14.0, "sh_b": -12.0, "face": "shout"}],
			[6, {"t": -12.0, "head": -26.0, "ua_f": 160.0, "fa_f": 180.0, "sa_f": 200.0, "th_f": 20.0, "sh_f": 0.0, "th_b": -14.0, "sh_b": -12.0, "face": "shout"}], [16, "crouch"]],
		"hits": [{"f": [8, 16], "seg": "sword_f", "r": 22.0, "dmg": 100.0, "stun": 22, "bstun": 16, "kb": 3.0, "lift": -14.0, "kd": true, "hs": 11, "spark": "slash", "sfx": "slash_h"}],
		"sfx": [[6, "swing_h"]], "trail": "sword_f", "crouch": true, "cancel": true,
	}
	moves.c_kick = {
		"anim": [[5, {"base": "crouch", "t": 34.0}], [3, {"base": "crouch", "t": 36.0, "th_f": 92.0, "sh_f": 92.0, "face": "attack"}], [5, {"base": "crouch", "t": 36.0, "th_f": 92.0, "sh_f": 92.0}], [13, "crouch"]],
		"hits": [{"f": [7, 13], "seg": "foot_f", "r": 18.0, "dmg": 60.0, "stun": 18, "bstun": 12, "kb": 4.0, "lvl": "low", "kd": true, "lift": -6.0, "hs": 8}],
		"sfx": [[4, "swing_m"]], "trail": "foot_f", "crouch": true,
	}
	moves.j_light = {
		"anim": [[3, {"base": "jump", "ua_f": 120.0, "fa_f": 170.0, "sa_f": 200.0}], [3, {"base": "jump", "ua_f": 70.0, "fa_f": 50.0, "sa_f": 40.0, "face": "attack"}], [10, {"base": "jump", "ua_f": 70.0, "fa_f": 45.0, "sa_f": 30.0}], [6, "jump"]],
		"hits": [{"f": [5, 14], "seg": "sword_f", "r": 16.0, "dmg": 50.0, "stun": 15, "bstun": 10, "kb": 4.0, "lvl": "high", "hs": 7, "spark": "slash", "sfx": "slash_l"}],
		"sfx": [[2, "swing_l"]], "trail": "sword_f", "air": true,
	}
	moves.j_heavy = {
		"anim": [[6, {"base": "jump", "ua_f": 160.0, "fa_f": 190.0, "sa_f": 230.0, "ua_b": 150.0, "fa_b": 185.0, "sa_b": 220.0, "face": "angry"}], [4, {"base": "jump", "t": 30.0, "ua_f": 80.0, "fa_f": 40.0, "sa_f": 20.0, "ua_b": 70.0, "fa_b": 35.0, "sa_b": 30.0, "face": "shout"}],
			[10, {"base": "jump", "t": 30.0, "ua_f": 80.0, "fa_f": 35.0, "sa_f": 15.0, "ua_b": 70.0, "fa_b": 30.0, "sa_b": 25.0}], [6, "jump"]],
		"hits": [{"f": [8, 18], "seg": "sword_f", "r": 22.0, "dmg": 110.0, "stun": 22, "bstun": 15, "kb": 6.0, "lvl": "high", "hs": 12, "spark": "slash", "sfx": "slash_h"}],
		"sfx": [[6, "swing_h"]], "trail": "sword_f", "air": true,
	}
	moves.j_kick = {
		"anim": [[4, {"base": "jump", "th_f": 60.0, "sh_f": 20.0}], [3, {"base": "jump", "t": -10.0, "th_f": 75.0, "sh_f": 70.0, "face": "attack"}], [12, {"base": "jump", "t": -10.0, "th_f": 75.0, "sh_f": 70.0}], [5, "jump"]],
		"hits": [{"f": [6, 18], "seg": "foot_f", "r": 20.0, "dmg": 55.0, "stun": 16, "bstun": 11, "kb": 5.0, "lvl": "high", "hs": 8}],
		"sfx": [[3, "swing_m"]], "trail": "foot_f", "air": true,
	}

	# --- specials
	var cross := {"t": -8.0, "ua_f": 120.0, "fa_f": 200.0, "sa_f": 250.0, "ua_b": 110.0, "fa_b": 190.0, "sa_b": 240.0, "face": "angry"}
	var sweep := {"t": 24.0, "head": -16.0, "ua_f": 95.0, "fa_f": 90.0, "sa_f": 95.0, "ua_b": 90.0, "fa_b": 80.0, "sa_b": 80.0, "th_f": 50.0, "sh_f": -6.0, "face": "shout"}
	moves.s1 = {
		"title": "Santoryu: 36 POUND PHOENIX!",
		"anim": [[11, cross], [4, sweep], [8, sweep], [14, "idle"]],
		"proj": [[13, {"type": "wind", "pos": [100, -150], "vel": [12, 0], "r": 40.0, "life": 80,
			"hit": {"dmg": 85.0, "stun": 20, "bstun": 16, "kb": 7.0, "hs": 9, "spark": "slash", "sfx": "slash_h", "chip": 0.1}}]],
		"sfx": [[11, "swing_h"], [12, "wind"]], "trail": "sword_f",
	}
	moves.s1_h = {
		"title": "Santoryu: 108 POUND PHOENIX!",
		"anim": [[18, {"t": -14.0, "head": 6.0, "ua_f": 100.0, "fa_f": 200.0, "sa_f": 260.0, "ua_b": 90.0, "fa_b": 195.0, "sa_b": 255.0, "th_f": 46.0, "face": "angry"}], [4, sweep], [10, sweep], [16, "idle"]],
		"proj": [[20, {"type": "wind", "pos": [110, -150], "vel": [8.5, 0], "r": 58.0, "size": 1.3, "life": 110, "hp": 3, "hits": 3, "every": 5,
			"hit": {"dmg": 48.0, "stun": 18, "bstun": 12, "kb": 4.0, "hs": 6, "spark": "slash", "sfx": "slash_l", "chip": 0.12}}]],
		"sfx": [[18, "swing_h"], [19, "wind"]], "trail": "sword_f", "shake_at": [[20, 5.0]],
	}
	moves.s2 = {
		"title": "Santoryu: ONI GIRI!",
		"anim": [[9, "oni"], [12, {"base": "oni", "t": 40.0, "hx": 0.0}], [4, "oni_end"], [20, "oni_end"], [10, "idle"]],
		"hits": [{"f": [10, 21], "seg": "pts", "pts": [[-20, -130], [110, -130]], "r": 52.0, "dmg": 135.0, "stun": 26, "bstun": 18, "kb": 5.0, "lift": -9.0, "kd": true, "hs": 15, "spark": "slash", "sfx": "slash_h", "chip": 0.12}],
		"vel": [[10, 24.0], [21, 3.0]], "slide": true, "pass": true, "sfx": [[9, "dash"], [10, "swing_h"]], "trail": "sword_f",
	}
	moves.s3 = {
		"title": "Santoryu: TATSUMAKI!",
		"anim": [[5, {"base": "crouch", "ua_f": 100.0, "fa_f": 160.0, "sa_f": 220.0, "ua_b": 100.0, "fa_b": 160.0, "sa_b": 200.0}],
			[8, {"t": 0.0, "rot": 360.0, "ua_f": 100.0, "fa_f": 100.0, "sa_f": 100.0, "ua_b": -100.0, "fa_b": -100.0, "sa_b": -100.0, "th_f": 20.0, "sh_f": 0.0, "th_b": -10.0, "sh_b": -6.0, "face": "shout"}],
			[8, {"t": 0.0, "rot": 720.0, "ua_f": 100.0, "fa_f": 100.0, "sa_f": 100.0, "ua_b": -100.0, "fa_b": -100.0, "sa_b": -100.0, "th_f": 20.0, "sh_f": 0.0, "th_b": -10.0, "sh_b": -6.0, "face": "shout"}],
			[8, {"t": 0.0, "rot": 1080.0, "ua_f": 100.0, "fa_f": 100.0, "sa_f": 100.0, "ua_b": -100.0, "fa_b": -100.0, "sa_b": -100.0, "th_f": 20.0, "sh_f": 0.0, "th_b": -10.0, "sh_b": -6.0, "face": "shout"}],
			[14, "jump"]],
		"hits": multi(6, 5, 4, {"seg": "pts", "pts": [[-30, -220], [30, -60]], "r": 80.0, "dmg": 26.0, "stun": 20, "bstun": 9, "kb": 2.0, "lift": -10.0, "kd": true, "hs": 4, "spark": "slash", "sfx": "slash_l", "chip": 0.1},
			{"dmg": 40.0, "lift": -12.0, "kb": 6.0, "hs": 10, "sfx": "slash_h"}),
		"vel": [[5, 1.5, -15.0]], "invuln": [1, 10], "fx": [[6, "tornado", [0, -120]], [12, "tornado", [0, -120]], [18, "tornado", [0, -120]]],
		"sfx": [[5, "wind"], [6, "swing_h"], [14, "swing_h"]],
	}
	moves["super"] = {
		"title": "Kyutoryu ASHURA: ICHIBUGIN!",
		"super": true,
		"anim": [[22, "ashura"], [10, {"base": "oni", "fx": "ashura"}], [12, {"base": "oni", "t": 40.0, "fx": "ashura"}], [4, {"base": "oni_end", "fx": "ashura"}], [28, {"base": "oni_end", "fx": "ashura"}], [12, "idle"]],
		"hits": multi(33, 4, 3, {"seg": "pts", "pts": [[-30, -130], [120, -130]], "r": 64.0, "dmg": 30.0, "stun": 40, "bstun": 14, "kb": 1.0, "hs": 3, "spark": "slash", "sfx": "slash_l", "chip": 0.15})
			+ [{"f": [58, 64], "seg": "pts", "pts": [[-420, -140], [-40, -140]], "r": 110.0, "dmg": 170.0, "stun": 30, "bstun": 20, "kb": 10.0, "lift": -13.0, "kd": true, "hs": 22, "spark": "slash", "sfx": "slash_h", "chip": 0.2}],
		"vel": [[33, 26.0], [45, 2.0]], "slide": true, "pass": true, "invuln": [1, 45],
		"fx": [[2, "dark_ring", [0, -140]], [57, "shock", [-200, -140]]],
		"sfx": [[2, "aura"], [32, "dash"], [33, "swing_h"], [56, "slash_h"]], "trail": "sword_f", "shake_at": [[58, 10.0]],
	}


# ---------------------------------------------------------------- drawing

func draw_torso_extra(cv: CanvasItem, _J: Dictionary, _p: Dictionary, st: Dictionary, L: float, ch: float) -> void:
	# shirt neckline and sleeve shading
	cv.draw_arc(Vector2(10 * ch, -L + 2), 9.0, 0.3, 2.6, 8, fc(col.top, st).darkened(0.35), 2.0, true)
	# green haramaki
	var h := PackedVector2Array([Vector2(-18 * ch, 9), Vector2(19 * ch, 9), Vector2(17 * ch, -L * 0.34), Vector2(-18 * ch, -L * 0.3)])
	shape(cv, h, Color("3c8f3c"), st)
	for i in 3:
		var y := -L * (0.06 + i * 0.1)
		cv.draw_line(Vector2(-16 * ch, y), Vector2(17 * ch, y - 1), fc(Color("2c6c2c"), st), 1.4, true)


func draw_hair(cv: CanvasItem, R: float, _p: Dictionary, st: Dictionary) -> void:
	# short spiky green hair
	spikes(cv, R * 0.97, 140.0, 352.0, 9, R * 0.3, col.hair, st, 0.45, Vector2(0, -R * 0.1), 11)
	var fr := PackedVector2Array([Vector2(R * 0.05, -R * 0.95), Vector2(R * 1.0, -R * 0.62), Vector2(R * 0.78, -R * 0.42), Vector2(R * 0.62, -R * 0.55), Vector2(R * 0.4, -R * 0.4), Vector2(R * 0.1, -R * 0.55)])
	shape(cv, fr, col.hair, st, false, 2.0)


func draw_face_extra(cv: CanvasItem, R: float, _p: Dictionary, st: Dictionary) -> void:
	# three gold earrings
	for i in 3:
		var e := Vector2(-R * 0.2, R * 0.3 + i * R * 0.1)
		cv.draw_line(e, e + Vector2(0, R * 0.14), fc(Color("f0c040"), st), 2.2, true)


func draw_head_extra(cv: CanvasItem, J: Dictionary, p: Dictionary, st: Dictionary) -> void:
	# third sword held in the mouth (Shusui, black handle)
	var R: float = dims.head
	cv.draw_set_transform(J.head, J.head_ang, Vector2.ONE)
	var m := Vector2(R * 0.72, R * 0.55)
	var ang := deg_to_rad(float(p.get("ma", 8.0)))
	var v := Vector2(cos(ang), sin(ang))
	_draw_blade(cv, m - v * 4.0, v, 92.0, Color("26202a"), st, 12.0)
	cv.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)


func draw_sword(cv: CanvasItem, J: Dictionary, _p: Dictionary, s: String, st: Dictionary) -> void:
	var hand: Vector2 = J["hand_" + s]
	var tip: Vector2 = J["tip_" + s]
	var v := (tip - hand).normalized()
	var handle := Color("f4f1e8") if s == "f" else Color("b0242c")
	_draw_blade(cv, hand - v * 20.0, v, hand.distance_to(tip) + 20.0, handle, st)


func _draw_blade(cv: CanvasItem, start: Vector2, v: Vector2, length: float, handle: Color, st: Dictionary, grip := 34.0) -> void:
	var n := Vector2(-v.y, v.x)
	var grip_end := start + v * grip
	shape(cv, capsule(start, grip_end, 4.5, 4.5, 3), handle, st, false, 1.8)
	# diamond wrap pattern
	for i in int(grip / 11.0):
		var c := start + v * (8.0 + i * 9.0)
		cv.draw_line(c - n * 4.0, c + n * 4.0, fc(handle, st).darkened(0.5), 1.4, true)
	var guard := grip_end + v * 2.0
	shape(cv, ellipse(guard, 3.5, 9.0, 10, v.angle()), Color("c9a03a"), st, false, 1.6)
	var b0 := guard + v * 3.0
	var tip := start + v * length
	var pts := PackedVector2Array()
	var steps := 8
	for i in steps + 1:
		var u := float(i) / steps
		var curve := sin(u * PI * 0.9) * 6.0
		var w := lerpf(3.6, 0.6, pow(u, 3.0))
		pts.append(b0.lerp(tip, u) + n * (curve + w))
	for i in range(steps, -1, -1):
		var u := float(i) / steps
		var curve := sin(u * PI * 0.9) * 6.0
		var w := lerpf(3.6, 0.6, pow(u, 3.0))
		pts.append(b0.lerp(tip, u) + n * (curve - w))
	if not Geometry2D.triangulate_polygon(pts).is_empty():
		cv.draw_colored_polygon(pts, fc(Color("d5dde6"), st))
	outline(cv, pts, 1.5)
	var edge := PackedVector2Array()
	for i in steps + 1:
		var u := float(i) / steps
		edge.append(b0.lerp(tip, u) + n * (sin(u * PI * 0.9) * 6.0 - 1.5))
	cv.draw_polyline(edge, Color(1, 1, 1, 0.9), 1.4, true)


func draw_back_fx(cv: CanvasItem, J: Dictionary, p: Dictionary, st: Dictionary) -> void:
	if p.get("fx", "") != "ashura":
		return
	var tt: float = st.get("time", 0.0)
	var c := Color(0.55, 0.25, 0.85, 0.28 + 0.08 * sin(tt * 9.0))
	var center: Vector2 = J.neck + Vector2(-10, 10)
	cv.draw_circle(center, 120.0, Color(0.3, 0.1, 0.5, 0.18))
	# ghost heads and arms of Asura
	for side in [-1, 1]:
		var hpos: Vector2 = J.head + Vector2(side * 38.0, 8.0)
		cv.draw_circle(hpos, dims.head * 0.95, c)
		for k in 2:
			var sh: Vector2 = J.shoulder + Vector2(side * 14.0, 10.0 + k * 22.0)
			var a := deg_to_rad(side * 70.0 + k * 25.0 * side + sin(tt * 5.0 + k) * 8.0 - 90.0)
			var hand := sh + Vector2(cos(a), sin(a)) * 80.0
			cv.draw_line(sh, hand, c, 12.0, true)
			var tip := hand + Vector2(cos(a - 0.5 * side), sin(a - 0.5 * side)) * 110.0
			cv.draw_line(hand, tip, Color(0.85, 0.75, 1.0, 0.45), 4.0, true)


func update_fx(f, fx) -> void:
	if String(f.pose.get("fx", "")) == "ashura" and Engine.get_physics_frames() % 2 == 0:
		var pos: Vector2 = f.world_point(f.J.hip) + Vector2(randf_range(-60, 60), randf_range(-150, 20))
		fx.smoke(pos, Color(0.45, 0.2, 0.7, 0.45), 1.6)
