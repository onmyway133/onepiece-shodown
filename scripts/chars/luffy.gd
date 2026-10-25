extends CharData
## Monkey D. Luffy: rubber body, long reach stretch attacks.


func setup() -> void:
	id = "luffy"
	display_name = "LUFFY"
	epithet = "Straw Hat"
	quote = "I'm gonna be King of the Pirates!"
	accent = Color("d63a2f")
	dims.thigh = 54.0
	dims.shin = 55.0
	dims.torso = 74.0
	dims.head = 28.0
	dims.ua = 40.0
	dims.fa = 38.0
	dims.chest = 1.1
	dims.limb = 1.0
	col.skin = Color("f0bf8c")
	col.hair = Color("161616")
	col.top = Color("c9282d")
	col.sleeve = Color("c9282d")
	col.pants = Color("2f62ad")
	col.cuff_c = Color("5e8fd6")
	col.shoes = Color("7a4a24")
	col.sash = Color("f0c330")
	style = {"top": "vest", "sleeves": "short", "pants": "short", "feet": "sandal", "cuff": true}
	walk_speed = 4.6
	back_speed = 3.6
	jump_vy = -20.0

	poses.idle = {"t": 10.0, "head": -10.0, "ua_f": 24.0, "fa_f": 140.0, "ua_b": 10.0, "fa_b": 128.0, "th_f": 30.0, "sh_f": -4.0, "th_b": -20.0, "sh_b": -24.0}
	poses.idle_b = {"hy": 4.0, "t": 13.0, "head": -12.0, "ua_f": 30.0, "fa_f": 134.0, "ua_b": 14.0, "fa_b": 122.0, "th_f": 34.0, "sh_f": -8.0, "th_b": -22.0, "sh_b": -22.0}
	poses.win = {"t": -4.0, "head": -14.0, "ua_f": 170.0, "fa_f": 178.0, "ua_b": -20.0, "fa_b": 30.0, "th_f": 14.0, "sh_f": 0.0, "th_b": -14.0, "sh_b": -4.0, "face": "grin"}
	poses.intro = {"t": 2.0, "head": -6.0, "ua_f": 150.0, "fa_f": 40.0, "ua_b": 8.0, "fa_b": 0.0, "th_f": 10.0, "sh_f": 0.0, "th_b": -10.0, "sh_b": -2.0, "face": "grin"}
	poses.gear2 = {"base": "crouch", "t": 30.0, "head": -16.0, "ua_f": 20.0, "fa_f": 80.0, "ua_b": -20.0, "fa_b": 60.0, "th_f": 90.0, "sh_f": 0.0, "th_b": 40.0, "sh_b": -88.0, "face": "angry", "fx": "gear2"}

	var punch := {"t": 16.0, "ua_f": 92.0, "fa_f": 92.0, "ua_b": -24.0, "fa_b": 40.0, "face": "attack"}

	moves.light = {
		"anim": [[4, {"t": 4.0, "ua_f": 68.0, "fa_f": 110.0, "face": "attack"}], [3, _m(punch, {"st_f": 2.1})], [3, _m(punch, {"st_f": 2.15})], [9, "idle"]],
		"hits": [{"f": [6, 10], "seg": "hand_f", "r": 18.0, "dmg": 40.0, "stun": 14, "bstun": 9, "kb": 4.5, "hs": 6, "sfx": "hit_l"}],
		"sfx": [[3, "swing_l"], [4, "stretch"]], "trail": "hand_f", "cancel": true, "chain": ["heavy", "kick"],
	}
	moves.heavy = {
		"anim": [[10, {"t": -12.0, "head": -4.0, "ua_f": -70.0, "fa_f": -110.0, "st_f": 1.3, "ua_b": 60.0, "fa_b": 150.0, "face": "angry"}],
			[3, {"t": 18.0, "ua_f": 60.0, "fa_f": 75.0, "st_f": 2.3, "ua_b": -30.0, "fa_b": 20.0, "face": "shout"}],
			[3, {"t": 24.0, "ua_f": 98.0, "fa_f": 115.0, "st_f": 2.6, "ua_b": -30.0, "fa_b": 20.0, "face": "shout"}],
			[4, {"t": 22.0, "ua_f": 108.0, "fa_f": 130.0, "st_f": 2.2, "face": "shout"}], [14, "idle"]],
		"hits": [{"f": [11, 17], "seg": "arm_f", "r": 22.0, "dmg": 100.0, "stun": 22, "bstun": 16, "kb": 8.0, "hs": 11, "spark": "heavy", "sfx": "hit_h"}],
		"sfx": [[9, "swing_h"], [10, "stretch"]], "trail": "hand_f", "cancel": true,
	}
	moves.kick = {
		"anim": [[6, {"t": -12.0, "th_f": 60.0, "sh_f": 10.0, "th_b": -14.0, "sh_b": -18.0, "ua_f": 40.0, "fa_f": 150.0}],
			[3, {"t": -26.0, "head": 10.0, "th_f": 102.0, "sh_f": 96.0, "sl_f": 1.9, "th_b": -10.0, "sh_b": -14.0, "face": "attack"}],
			[4, {"t": -26.0, "head": 10.0, "th_f": 100.0, "sh_f": 94.0, "sl_f": 1.95, "th_b": -10.0, "sh_b": -14.0, "face": "attack"}], [11, "idle"]],
		"hits": [{"f": [8, 13], "seg": "foot_f", "r": 20.0, "dmg": 65.0, "stun": 17, "bstun": 12, "kb": 6.0, "hs": 8}],
		"sfx": [[5, "swing_m"], [6, "stretch"]], "trail": "foot_f", "cancel": true,
	}
	moves.c_light = {
		"anim": [[3, {"base": "crouch", "ua_f": 70.0, "fa_f": 120.0}], [3, {"base": "crouch", "ua_f": 88.0, "fa_f": 88.0, "st_f": 1.8, "face": "attack"}], [3, {"base": "crouch", "ua_f": 88.0, "fa_f": 88.0, "st_f": 1.8}], [8, "crouch"]],
		"hits": [{"f": [5, 9], "seg": "hand_f", "r": 17.0, "dmg": 32.0, "stun": 13, "bstun": 8, "kb": 4.0, "hs": 5, "lvl": "low", "sfx": "hit_l"}],
		"sfx": [[2, "swing_l"]], "trail": "hand_f", "crouch": true, "cancel": true, "chain": ["c_heavy", "c_kick"],
	}
	moves.c_heavy = {
		"anim": [[6, {"base": "crouch", "t": 30.0, "ua_f": -20.0, "fa_f": 60.0}], [4, {"t": -6.0, "head": -26.0, "ua_f": 165.0, "fa_f": 172.0, "st_f": 2.3, "th_f": 20.0, "sh_f": 0.0, "th_b": -14.0, "sh_b": -10.0, "face": "shout"}],
			[6, {"t": -6.0, "head": -26.0, "ua_f": 168.0, "fa_f": 175.0, "st_f": 2.4, "th_f": 20.0, "sh_f": 0.0, "th_b": -14.0, "sh_b": -10.0, "face": "shout"}], [14, "crouch"]],
		"hits": [{"f": [8, 16], "seg": "arm_f", "r": 24.0, "dmg": 85.0, "stun": 20, "bstun": 14, "kb": 3.0, "lift": -14.0, "kd": true, "hs": 10, "spark": "heavy", "sfx": "hit_h"}],
		"sfx": [[5, "swing_h"], [6, "stretch"]], "trail": "hand_f", "crouch": true, "cancel": true,
	}
	moves.c_kick = {
		"anim": [[5, {"base": "crouch", "t": 34.0}], [3, {"base": "crouch", "t": 36.0, "th_f": 92.0, "sh_f": 92.0, "sl_f": 1.8, "face": "attack"}], [5, {"base": "crouch", "t": 36.0, "th_f": 92.0, "sh_f": 92.0, "sl_f": 1.85}], [12, "crouch"]],
		"hits": [{"f": [7, 13], "seg": "foot_f", "r": 18.0, "dmg": 60.0, "stun": 18, "bstun": 12, "kb": 4.0, "lvl": "low", "kd": true, "lift": -6.0, "hs": 8}],
		"sfx": [[4, "swing_m"], [5, "stretch"]], "trail": "foot_f", "crouch": true,
	}
	moves.j_light = {
		"anim": [[3, {"base": "jump", "ua_f": 60.0, "fa_f": 100.0}], [3, {"base": "jump", "ua_f": 62.0, "fa_f": 62.0, "st_f": 1.8, "face": "attack"}], [10, {"base": "jump", "ua_f": 62.0, "fa_f": 62.0, "st_f": 1.7}], [6, "jump"]],
		"hits": [{"f": [5, 14], "seg": "hand_f", "r": 18.0, "dmg": 42.0, "stun": 15, "bstun": 10, "kb": 4.0, "lvl": "high", "hs": 6, "sfx": "hit_l"}],
		"sfx": [[2, "swing_l"]], "trail": "hand_f", "air": true,
	}
	moves.j_heavy = {
		"anim": [[6, {"base": "jump", "ua_f": 175.0, "fa_f": 175.0, "ua_b": 170.0, "fa_b": 175.0, "face": "angry"}], [3, {"base": "jump", "t": 30.0, "ua_f": 55.0, "fa_f": 40.0, "ua_b": 50.0, "fa_b": 35.0, "st_f": 2.0, "st_b": 2.0, "face": "shout"}],
			[10, {"base": "jump", "t": 30.0, "ua_f": 50.0, "fa_f": 35.0, "ua_b": 45.0, "fa_b": 30.0, "st_f": 2.0, "st_b": 2.0, "face": "shout"}], [6, "jump"]],
		"hits": [{"f": [8, 18], "seg": "arm_f", "r": 24.0, "dmg": 90.0, "stun": 20, "bstun": 14, "kb": 6.0, "lvl": "high", "hs": 10, "spark": "heavy", "sfx": "hit_h"}],
		"sfx": [[6, "swing_h"], [7, "stretch"]], "trail": "hand_f", "air": true,
	}
	moves.j_kick = {
		"anim": [[4, {"base": "jump", "th_f": 60.0, "sh_f": 20.0}], [3, {"base": "jump", "t": -10.0, "th_f": 70.0, "sh_f": 64.0, "sl_f": 1.6, "face": "attack"}], [12, {"base": "jump", "t": -10.0, "th_f": 70.0, "sh_f": 64.0, "sl_f": 1.6}], [5, "jump"]],
		"hits": [{"f": [6, 18], "seg": "foot_f", "r": 20.0, "dmg": 60.0, "stun": 16, "bstun": 11, "kb": 5.0, "lvl": "high", "hs": 8}],
		"sfx": [[3, "swing_m"]], "trail": "foot_f", "air": true,
	}

	# --- specials
	moves.s1 = {
		"title": "Gomu Gomu no PISTOL!",
		"anim": [[9, {"t": -14.0, "head": -2.0, "ua_f": -40.0, "fa_f": 100.0, "ua_b": 70.0, "fa_b": 160.0, "face": "shout"}],
			[5, {"t": 18.0, "ua_f": 91.0, "fa_f": 91.0, "st_f": 5.6, "ua_b": -30.0, "fa_b": 20.0, "face": "shout"}],
			[6, {"t": 18.0, "ua_f": 91.0, "fa_f": 91.0, "st_f": 5.8, "ua_b": -30.0, "fa_b": 20.0, "face": "shout"}],
			[7, {"t": 12.0, "ua_f": 91.0, "fa_f": 91.0, "st_f": 1.4}], [10, "idle"]],
		"hits": [{"f": [12, 20], "seg": "arm_f", "r": 20.0, "dmg": 115.0, "stun": 24, "bstun": 18, "kb": 10.0, "hs": 10, "spark": "heavy", "sfx": "hit_h", "chip": 0.1}],
		"sfx": [[8, "swing_h"], [9, "stretch"], [22, "stretch"]], "trail": "hand_f",
	}
	moves.s1_h = {
		"title": "Gomu Gomu no BAZOOKA!",
		"anim": [[12, {"t": -22.0, "head": 6.0, "ua_f": -95.0, "fa_f": -95.0, "ua_b": -100.0, "fa_b": -100.0, "st_f": 1.9, "st_b": 1.9, "face": "angry"}],
			[4, {"t": 24.0, "ua_f": 88.0, "fa_f": 92.0, "ua_b": 94.0, "fa_b": 98.0, "st_f": 2.4, "st_b": 2.4, "face": "shout"}],
			[6, {"t": 24.0, "ua_f": 88.0, "fa_f": 92.0, "ua_b": 94.0, "fa_b": 98.0, "st_f": 2.5, "st_b": 2.5, "face": "shout"}], [16, "idle"]],
		"hits": [{"f": [14, 21], "seg": "arm_f", "r": 32.0, "dmg": 150.0, "stun": 30, "bstun": 20, "kb": 15.0, "lift": -9.0, "kd": true, "hs": 14, "spark": "heavy", "sfx": "hit_h", "chip": 0.12}],
		"sfx": [[2, "stretch"], [12, "swing_h"]], "trail": "hand_f", "zoom": true,
	}
	var gat := {"t": 18.0, "head": -12.0, "ua_f": 90.0, "fa_f": 90.0, "st_f": 2.0, "ua_b": 84.0, "fa_b": 84.0, "st_b": 1.8, "face": "shout", "fx": "gatling"}
	moves.s2 = {
		"title": "Gomu Gomu no GATLING!",
		"anim": [[8, {"t": -10.0, "ua_f": -40.0, "fa_f": 100.0, "ua_b": -50.0, "fa_b": 90.0, "face": "angry"}], [42, gat], [12, "idle"]],
		"hits": multi(10, 9, 5, {"seg": "pts", "pts": [[40, -150], [235, -150]], "r": 46.0, "dmg": 15.0, "stun": 14, "bstun": 9, "kb": 2.2, "hs": 3, "sfx": "hit_l", "chip": 0.15},
			{"dmg": 34.0, "kb": 11.0, "kd": true, "lift": -7.0, "hs": 10, "sfx": "hit_h", "spark": "heavy"}),
		"sfx": [[8, "gatling"]], "vel": [[9, 2.5]],
	}
	moves.s3 = {
		"title": "Gomu Gomu no ONO!",
		"anim": [[5, {"base": "crouch", "t": 10.0}],
			[6, {"t": -24.0, "head": 4.0, "th_f": 176.0, "sh_f": 180.0, "sl_f": 2.6, "ua_f": 40.0, "fa_f": 10.0, "ua_b": -40.0, "fa_b": -10.0, "th_b": -6.0, "sh_b": -6.0, "face": "shout"}],
			[8, {"t": -24.0, "head": 4.0, "th_f": 178.0, "sh_f": 181.0, "sl_f": 2.7, "ua_f": 40.0, "fa_f": 10.0, "ua_b": -40.0, "fa_b": -10.0, "th_b": -6.0, "sh_b": -6.0, "face": "shout"}],
			[4, {"t": 34.0, "head": -20.0, "th_f": 86.0, "sh_f": 90.0, "sl_f": 2.4, "ua_f": -20.0, "fa_f": 10.0, "th_b": -10.0, "sh_b": -10.0, "face": "shout"}],
			[6, {"t": 34.0, "head": -20.0, "th_f": 84.0, "sh_f": 88.0, "sl_f": 2.4, "ua_f": -20.0, "fa_f": 10.0, "th_b": -10.0, "sh_b": -10.0, "face": "shout"}], [14, "idle"]],
		"hits": [{"f": [7, 18], "seg": "foot_f", "r": 26.0, "dmg": 70.0, "stun": 20, "bstun": 14, "kb": 3.0, "lift": -12.0, "kd": true, "hs": 8},
			{"f": [21, 28], "seg": "foot_f", "r": 30.0, "dmg": 105.0, "stun": 24, "bstun": 16, "kb": 6.0, "lvl": "high", "kd": true, "hs": 13, "spark": "heavy", "sfx": "hit_h", "chip": 0.1}],
		"sfx": [[4, "stretch"], [19, "swing_h"]], "trail": "foot_f", "invuln": [1, 10], "shake_at": [[22, 6.0]],
	}
	var jet := gat.duplicate()
	jet.fx = "jet"
	jet.t = 24.0
	moves["super"] = {
		"title": "Gear Second: JET GATLING!",
		"super": true,
		"anim": [[18, "gear2"], [8, {"t": -10.0, "ua_f": -40.0, "fa_f": 100.0, "ua_b": -50.0, "fa_b": 90.0, "face": "angry", "fx": "gear2"}], [46, jet],
			[10, {"t": -20.0, "ua_f": -95.0, "fa_f": -95.0, "ua_b": -100.0, "fa_b": -100.0, "st_f": 1.9, "st_b": 1.9, "face": "angry", "fx": "gear2"}],
			[4, {"t": 26.0, "ua_f": 88.0, "fa_f": 92.0, "ua_b": 94.0, "fa_b": 98.0, "st_f": 2.8, "st_b": 2.8, "face": "shout", "fx": "gear2"}],
			[8, {"t": 26.0, "ua_f": 88.0, "fa_f": 92.0, "ua_b": 94.0, "fa_b": 98.0, "st_f": 2.8, "st_b": 2.8, "face": "shout", "fx": "gear2"}], [16, "idle"]],
		"hits": multi(28, 14, 3, {"seg": "pts", "pts": [[40, -150], [260, -150]], "r": 56.0, "dmg": 14.0, "stun": 18, "bstun": 8, "kb": 1.2, "hs": 2, "sfx": "hit_l", "chip": 0.2})
			+ [{"f": [86, 93], "seg": "arm_f", "r": 36.0, "dmg": 130.0, "stun": 30, "bstun": 20, "kb": 18.0, "lift": -11.0, "kd": true, "hs": 18, "spark": "heavy", "sfx": "hit_h", "chip": 0.2}],
		"sfx": [[2, "steam"], [26, "gatling"], [72, "stretch"], [84, "swing_h"]], "vel": [[27, 3.0]], "invuln": [1, 26], "zoom": true,
	}


static func _m(a: Dictionary, b: Dictionary) -> Dictionary:
	var d := a.duplicate()
	d.merge(b, true)
	return d


func draw_torso_extra(cv: CanvasItem, _J: Dictionary, _p: Dictionary, st: Dictionary, L: float, ch: float) -> void:
	# X scar on the chest
	var sc := fc(col.skin, st).darkened(0.4)
	var c := Vector2(9 * ch, -L * 0.6)
	cv.draw_line(c + Vector2(-5, -5), c + Vector2(5, 5), sc, 2.0, true)
	cv.draw_line(c + Vector2(-5, 5), c + Vector2(5, -5), sc, 2.0, true)
	# open red cardigan: back panel and front lapel
	var back := PackedVector2Array([Vector2(-16 * ch, -L * 0.16), Vector2(1, -L * 0.18), Vector2(4, -L * 0.92), Vector2(-1, -L - 2), Vector2(-16 * ch, -L + 1), Vector2(-20 * ch, -L * 0.6)])
	shape(cv, back, col.top, st)
	var lap := PackedVector2Array([Vector2(13 * ch, -L * 0.2), Vector2(17 * ch, -L * 0.24), Vector2(20 * ch, -L * 0.68), Vector2(15 * ch, -L - 3), Vector2(9 * ch, -L * 0.95), Vector2(15 * ch, -L * 0.64)])
	shape(cv, lap, col.top, st)


func draw_hair_back(cv: CanvasItem, R: float, _p: Dictionary, st: Dictionary) -> void:
	spikes(cv, R, 110.0, 250.0, 5, R * 0.42, col.hair, st, 0.4, Vector2(-R * 0.1, -R * 0.05), 3)


func draw_hair(cv: CanvasItem, R: float, _p: Dictionary, st: Dictionary) -> void:
	spikes(cv, R * 0.98, 200.0, 345.0, 6, R * 0.34, col.hair, st, 0.35, Vector2(-R * 0.05, -R * 0.12), 7)
	# bangs over the forehead
	var b := PackedVector2Array([Vector2(R * 0.1, -R * 0.85), Vector2(R * 0.95, -R * 0.55), Vector2(R * 0.72, -R * 0.2), Vector2(R * 0.58, -R * 0.45), Vector2(R * 0.42, -R * 0.12), Vector2(R * 0.28, -R * 0.42), Vector2(R * 0.05, -R * 0.2)])
	shape(cv, b, col.hair, st, false, 2.0)


func draw_hat(cv: CanvasItem, R: float, p: Dictionary, st: Dictionary) -> void:
	if p.get("fx", "") == "nohat":
		return
	var straw := Color("f2cf5b")
	var crown := PackedVector2Array()
	for i in 13:
		var a := PI + PI * float(i) / 12.0
		crown.append(Vector2(-R * 0.05 + cos(a) * R * 0.92, -R * 0.62 + sin(a) * R * 0.78))
	shape(cv, ellipse(Vector2(0, -R * 0.62), R * 1.75, R * 0.3, 22, -0.06), straw, st)
	shape(cv, crown, straw, st)
	var band := PackedVector2Array([Vector2(-R * 0.97, -R * 0.66), Vector2(R * 0.87, -R * 0.66), Vector2(R * 0.84, -R * 0.9), Vector2(-R * 0.93, -R * 0.9)])
	shape(cv, band, Color("c0262d"), st, false, 2.0)
	var line := fc(straw, st).darkened(0.3)
	var ring := PackedVector2Array()
	for i in 9:
		var a := 0.15 + (PI - 0.3) * float(i) / 8.0
		ring.append(Vector2(cos(a) * R * 1.4, -R * 0.62 + sin(a) * R * 0.17).rotated(-0.06))
	cv.draw_polyline(ring, line, 1.3, true)


func draw_face_extra(cv: CanvasItem, R: float, _p: Dictionary, st: Dictionary) -> void:
	var c := Vector2(R * 0.46, R * 0.3)
	var sc := fc(col.skin, st).darkened(0.45)
	cv.draw_line(c + Vector2(-R * 0.12, 0), c + Vector2(R * 0.12, 0), sc, 1.6, true)
	for i in 3:
		var x := -R * 0.08 + i * R * 0.08
		cv.draw_line(c + Vector2(x, -R * 0.05), c + Vector2(x, R * 0.05), sc, 1.2, true)


func draw_front_fx(cv: CanvasItem, J: Dictionary, p: Dictionary, st: Dictionary) -> void:
	var fx: String = p.get("fx", "")
	if fx == "gatling" or fx == "jet":
		var rng := RandomNumberGenerator.new()
		rng.seed = int(st.get("time", 0.0) * 60.0)
		var n := 9 if fx == "gatling" else 14
		var arm := fc(col.skin, st)
		if fx == "jet":
			arm = arm.lerp(Color("ff8a8a"), 0.4)
		for i in n:
			var ang := deg_to_rad(rng.randf_range(-22.0, 22.0))
			var length := rng.randf_range(110.0, 250.0)
			var a: Vector2 = J.shoulder
			var b := a + Vector2(cos(ang), sin(ang)) * length
			var c := arm
			c.a = 0.55
			cv.draw_colored_polygon(capsule(a, b, 7.0, 6.0, 4), c)
			cv.draw_circle(b, 11.0, Color(c.r, c.g, c.b, 0.85))
			cv.draw_arc(b, 11.0, 0.0, TAU, 10, Color(OUTLINE, 0.7), 1.8, true)
			var w := Color(1, 1, 1, 0.6)
			cv.draw_line(b + Vector2(10, rng.randf_range(-8, 8)), b + Vector2(40, rng.randf_range(-8, 8)), w, 2.0, true)


func update_fx(f, fx) -> void:
	var p: Dictionary = f.pose
	if String(p.get("fx", "")) in ["gear2", "jet"] and Engine.get_physics_frames() % 3 == 0:
		var pos: Vector2 = f.world_point(f.J.neck) + Vector2(randf_range(-25, 25), randf_range(-10, 30))
		fx.smoke(pos, Color(1, 1, 1, 0.55), 1.2)


func tint_for(p: Dictionary) -> Color:
	if String(p.get("fx", "")) in ["gear2", "jet"]:
		return Color(1.0, 0.45, 0.5, 0.35)
	return Color(0, 0, 0, 0)
