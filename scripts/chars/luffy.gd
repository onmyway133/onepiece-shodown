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
	dims.head = 25.0
	dims.ua = 40.0
	dims.fa = 38.0
	dims.chest = 1.22
	dims.limb = 1.0
	col.skin = Color("f0bf8c")
	col.hair = Color("161616")
	col.top = Color("c9282d")
	col.sleeve = Color("c9282d")
	col.pants = Color("2f62ad")
	col.cuff_c = Color("e8e2d5")
	col.shoes = Color("7a4a24")
	col.sash = Color("f0c330")
	style = {"top": "vest", "sleeves": "short", "pants": "short", "feet": "sandal", "cuff": true, "sash_tail": true}
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
	# post-timeskip cross-shaped Akainu scar on chest
	var sc_fill := fc(col.skin, st).darkened(0.28).lerp(Color("b84a48"), 0.35)
	var sc_line := fc(col.skin, st).darkened(0.45)
	var c := Vector2(8.5 * ch, -L * 0.62)
	var scar_pts := PackedVector2Array([
		c + Vector2(-7, -7), c + Vector2(-2, -3), c + Vector2(3, -7), c + Vector2(6, -5),
		c + Vector2(2, 0), c + Vector2(7, 6), c + Vector2(4, 8), c + Vector2(-1, 3),
		c + Vector2(-6, 7), c + Vector2(-8, 4), c + Vector2(-3, -1), c + Vector2(-8, -5),
	])
	if not Geometry2D.triangulate_polygon(scar_pts).is_empty():
		cv.draw_colored_polygon(scar_pts, sc_fill)
	outline(cv, scar_pts, 1.3, sc_line)
	# open red cardigan: back panel, front lapel, and gold buttons
	var back := PackedVector2Array([Vector2(-16.5 * ch, -L * 0.14), Vector2(1, -L * 0.16), Vector2(4, -L * 0.92), Vector2(-1, -L - 2), Vector2(-16.5 * ch, -L + 1), Vector2(-20.5 * ch, -L * 0.6)])
	shape(cv, back, col.top, st)
	var lap := PackedVector2Array([Vector2(12.5 * ch, -L * 0.16), Vector2(17.5 * ch, -L * 0.22), Vector2(20.5 * ch, -L * 0.68), Vector2(15.5 * ch, -L - 3), Vector2(9 * ch, -L * 0.95), Vector2(14.5 * ch, -L * 0.62)])
	shape(cv, lap, col.top, st)
	for i in 3:
		cv.draw_circle(Vector2(14.5 * ch, -L * (0.32 + i * 0.22)), 1.9, fc(Color("f2cf5b"), st))
	# pleated yellow waist sash over the shorts
	var sash_pts := PackedVector2Array([Vector2(-17.5 * ch, 9.0), Vector2(18.0 * ch, 9.0), Vector2(16.8 * ch, -3.5), Vector2(-16.8 * ch, -2.5)])
	shape(cv, sash_pts, col.sash, st, true, 1.8)
	var s_line := shadow_of(fc(col.sash, st)).darkened(0.15)
	cv.draw_line(Vector2(-15 * ch, 3.0), Vector2(16 * ch, 2.5), s_line, 1.4, true)


func draw_hair_back(cv: CanvasItem, R: float, _p: Dictionary, st: Dictionary) -> void:
	spikes(cv, R, 95.0, 255.0, 7, R * 0.48, col.hair, st, 0.4, Vector2(-R * 0.1, -R * 0.05), 3, -16.0)


func draw_hair(cv: CanvasItem, R: float, _p: Dictionary, st: Dictionary) -> void:
	spikes(cv, R * 0.98, 190.0, 340.0, 7, R * 0.34, col.hair, st, 0.35, Vector2(-R * 0.05, -R * 0.12), 7, -18.0)
	# messy fringe over the forehead, short enough to show the eyes
	var b := local_pts(Vector2.ZERO, Vector2.RIGHT, Vector2.DOWN, R, [[-0.32, -0.98], [0.42, -1.02], [0.94, -0.7], [1.06, -0.34], [0.84, -0.5], [0.72, -0.28], [0.58, -0.52], [0.44, -0.32], [0.3, -0.56], [0.12, -0.34], [0.02, -0.58], [-0.24, -0.5]])
	shape(cv, b, col.hair, st, true, 2.2)


func draw_hat(cv: CanvasItem, R: float, p: Dictionary, st: Dictionary) -> void:
	if p.get("fx", "") == "nohat":
		return
	var straw := Color("f2cf5b")
	var crown := PackedVector2Array()
	for i in 13:
		var a := PI + PI * float(i) / 12.0
		crown.append(Vector2(-R * 0.05 + cos(a) * R * 0.94, -R * 0.62 + sin(a) * R * 0.8))
	shape(cv, ellipse(Vector2(0, -R * 0.62), R * 1.82, R * 0.32, 24, -0.06), straw, st)
	shape(cv, crown, straw, st)
	var band := PackedVector2Array([Vector2(-R * 0.98, -R * 0.66), Vector2(R * 0.88, -R * 0.66), Vector2(R * 0.85, -R * 0.92), Vector2(-R * 0.94, -R * 0.92)])
	shape(cv, band, Color("c4242b"), st, true, 2.0)
	var line := fc(straw, st).darkened(0.28)
	var ring := PackedVector2Array()
	for i in 9:
		var a := 0.15 + (PI - 0.3) * float(i) / 8.0
		ring.append(Vector2(cos(a) * R * 1.45, -R * 0.62 + sin(a) * R * 0.18).rotated(-0.06))
	cv.draw_polyline(ring, line, 1.3, true)
	# straw weave texture lines on crown
	for k in 3:
		var x := (-0.45 + k * 0.42) * R
		cv.draw_line(Vector2(x, -R * 0.92), Vector2(x * 0.85, -R * 1.32), Color(line, 0.55), 1.2, true)


func draw_face_extra(cv: CanvasItem, R: float, _p: Dictionary, st: Dictionary) -> void:
	# the stitched scar under the eye
	var c := Vector2(R * 0.12, R * 0.46)
	var sc := fc(col.skin, st).darkened(0.45)
	cv.draw_line(c + Vector2(-R * 0.12, 0), c + Vector2(R * 0.12, 0), sc, 1.6, true)
	for i in 3:
		var x := -R * 0.08 + i * R * 0.08
		cv.draw_line(c + Vector2(x, -R * 0.05), c + Vector2(x, R * 0.05), sc, 1.2, true)


func draw_front_fx(cv: CanvasItem, J: Dictionary, p: Dictionary, st: Dictionary) -> void:
	var fx: String = p.get("fx", "")
	if fx == "gear3":
		_draw_giant_arm(cv, J, st, 1.0)
	elif fx == "gear3_charge":
		_draw_giant_arm(cv, J, st, 0.35 + 0.4 * clampf(fmod(float(st.get("time", 0.0)) * 1.6, 1.0), 0.0, 1.0))
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
	if String(p.get("fx", "")) in ["gear2", "jet", "gear3", "gear3_charge"] and Engine.get_physics_frames() % 3 == 0:
		var pos: Vector2 = f.world_point(f.J.neck) + Vector2(randf_range(-25, 25), randf_range(-10, 30))
		fx.smoke(pos, Color(1, 1, 1, 0.55), 1.2)


func tint_for(p: Dictionary) -> Color:
	if String(p.get("fx", "")) in ["gear2", "jet"]:
		return Color(1.0, 0.45, 0.5, 0.35)
	return Color(0, 0, 0, 0)


# ---------------------------------------------------------------- more moves

func more_moves() -> void:
	moves.s2_h = {
		"title": "Gomu Gomu no MUCHI!",
		"anim": [[6, {"base": "crouch", "t": 20.0, "th_f": 60.0, "sh_f": 30.0}],
			[4, {"base": "crouch", "t": 30.0, "head": -20.0, "th_f": 88.0, "sh_f": 90.0, "sl_f": 3.6, "face": "shout"}],
			[8, {"base": "crouch", "t": 30.0, "head": -20.0, "th_f": 86.0, "sh_f": 88.0, "sl_f": 3.8, "face": "shout"}],
			[6, {"base": "crouch", "t": 26.0, "th_f": 80.0, "sh_f": 70.0, "sl_f": 1.6}], [12, "crouch"]],
		"hits": [{"f": [8, 18], "seg": "leg_f", "r": 22.0, "dmg": 90.0, "stun": 20, "bstun": 14, "kb": 6.0, "lvl": "low", "kd": true, "lift": -5.0, "hs": 10, "spark": "heavy", "sfx": "hit_h", "chip": 0.08}],
		"sfx": [[5, "stretch"], [7, "swing_h"]], "trail": "foot_f", "crouch": true,
	}
	moves.s3_h = {
		"title": "Gomu Gomu no ROCKET!",
		"anim": [[10, {"t": -20.0, "ua_f": 150.0, "fa_f": 160.0, "st_f": 2.6, "ua_b": 140.0, "fa_b": 150.0, "st_b": 2.6, "face": "angry"}],
			[6, {"rot": 70.0, "t": 0.0, "head": -60.0, "ua_f": 175.0, "fa_f": 178.0, "ua_b": 172.0, "fa_b": 176.0, "th_f": 4.0, "sh_f": 0.0, "th_b": -4.0, "sh_b": 0.0, "face": "shout"}],
			[16, {"rot": 80.0, "t": 0.0, "head": -70.0, "ua_f": 178.0, "fa_f": 179.0, "ua_b": 175.0, "fa_b": 178.0, "th_f": 4.0, "sh_f": 0.0, "th_b": -4.0, "sh_b": 0.0, "face": "shout"}],
			[12, "jump"]],
		"hits": [{"f": [11, 30], "seg": "body", "r": 42.0, "dmg": 120.0, "stun": 24, "bstun": 16, "kb": 10.0, "lift": -10.0, "kd": true, "hs": 13, "spark": "heavy", "sfx": "hit_h", "chip": 0.1}],
		"vel": [[10, 18.0, -9.0]], "ghost": true, "sfx": [[2, "stretch"], [10, "dash"]],
	}
	moves.s4 = {
		"title": "Gomu Gomu no STAMP!",
		"anim": [[6, {"base": "crouch"}], [8, {"base": "jump", "t": -10.0, "th_f": 120.0, "sh_f": 60.0}],
			[4, {"t": -24.0, "head": 10.0, "th_f": 100.0, "sh_f": 100.0, "sl_f": 2.4, "th_b": -10.0, "sh_b": -20.0, "ua_f": 40.0, "fa_f": 60.0, "face": "shout"}],
			[10, {"t": -24.0, "head": 10.0, "th_f": 100.0, "sh_f": 102.0, "sl_f": 2.6, "th_b": -10.0, "sh_b": -20.0, "ua_f": 40.0, "fa_f": 60.0, "face": "shout"}], [10, "idle"]],
		"hits": [{"f": [16, 26], "seg": "foot_f", "r": 28.0, "dmg": 100.0, "stun": 22, "bstun": 16, "kb": 9.0, "lvl": "high", "hs": 11, "spark": "heavy", "sfx": "hit_h", "chip": 0.08}],
		"vel": [[6, 6.0, -12.0]], "sfx": [[5, "jump"], [14, "stretch"], [15, "swing_h"]], "trail": "foot_f",
	}
	moves.super2 = {
		"title": "Gear Third: GIGANT PISTOL!",
		"super": true,
		"anim": [[24, {"t": -10.0, "head": 0.0, "ua_f": -70.0, "fa_f": -20.0, "ua_b": 60.0, "fa_b": 120.0, "face": "angry", "fx": "gear3_charge"}],
			[16, {"t": -18.0, "head": 4.0, "ua_f": -110.0, "fa_f": -100.0, "st_f": 1.4, "ua_b": 70.0, "fa_b": 140.0, "face": "angry", "fx": "gear3"}],
			[5, {"t": 22.0, "ua_f": 90.0, "fa_f": 90.0, "st_f": 3.2, "ua_b": -30.0, "fa_b": 20.0, "th_f": 50.0, "face": "shout", "fx": "gear3"}],
			[16, {"t": 22.0, "ua_f": 90.0, "fa_f": 90.0, "st_f": 3.4, "ua_b": -30.0, "fa_b": 20.0, "th_f": 50.0, "face": "shout", "fx": "gear3"}],
			[16, "idle"]],
		"hits": [{"f": [42, 58], "seg": "pts", "pts": [[60, -170], [330, -170]], "r": 95.0, "dmg": 300.0, "stun": 40, "bstun": 24, "kb": 22.0, "lift": -12.0, "kd": true, "hs": 22, "spark": "heavy", "sfx": "hit_h", "chip": 0.25}],
		"sfx": [[2, "steam"], [20, "aura"], [40, "swing_h"]], "invuln": [1, 40], "zoom": true, "shake_at": [[44, 14.0]],
	}


## Gear Third: the inflated giant arm and fist.
func _draw_giant_arm(cv: CanvasItem, J: Dictionary, st: Dictionary, grow: float) -> void:
	var el: Vector2 = J.elbow_f
	var hand: Vector2 = J.hand_f
	var d := (hand - el).normalized()
	if d == Vector2.ZERO:
		d = Vector2.RIGHT
	var big := 70.0 * grow
	shape(cv, muscle(J.shoulder, hand, 16.0, 26.0 * grow, Vector2(0.7, 0.2), Vector2(0.6, 0.15)), col.skin, st)
	var c := hand + d * big * 0.55
	var fist := ellipse(c, big, big * 0.85, 24, d.angle())
	shape(cv, fist, col.skin, st, true, 3.0)
	var n := Vector2(-d.y, d.x)
	var line := shadow_of(fc(col.skin, st)).darkened(0.3)
	for k in 3:
		var y := (float(k) - 1.0) * big * 0.42
		cv.draw_line(c + d * big * 0.45 + n * y, c + d * big * 0.9 + n * y * 0.9, line, 3.0, true)
	shape(cv, ellipse(c - d * big * 0.1 - n * big * 0.62, big * 0.42, big * 0.24, 14, d.angle() + 0.3), col.skin, st, true, 2.6)
