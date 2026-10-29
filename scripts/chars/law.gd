extends CharData
## Trafalgar Law: Op-Op fruit surgeon. ROOM based tricks: slices at range,
## Shambles teleports behind the opponent, and electric shocks.


func setup() -> void:
	id = "law"
	display_name = "LAW"
	epithet = "Surgeon of Death"
	quote = "ROOM. You're already on my table."
	accent = Color("2f86c9")
	trail_color = Color(0.6, 0.85, 1.0)
	has_swords = true
	ai_zoner = true
	dims.thigh = 60.0
	dims.shin = 60.0
	dims.torso = 80.0
	dims.head = 23.0
	dims.ua = 43.0
	dims.fa = 41.0
	dims.chest = 1.14
	dims.limb = 0.95
	dims.sword = 150.0
	col.skin = Color("deb08a")
	col.hair = Color("15161c")
	col.top = Color("e8c14a")
	col.sleeve = Color("16161b")
	col.pants = Color("4a6596")
	col.shoes = Color("1b1b20")
	col.eye = Color("6d5a2c")
	style = {"top": "shirt", "sleeves": "long", "pants": "long", "feet": "shoe", "cuff": false}
	walk_speed = 4.2
	back_speed = 3.4
	max_hp = 960.0

	poses.idle = {"t": 6.0, "head": -6.0, "ua_f": 40.0, "fa_f": 160.0, "sa_f": -130.0, "ua_b": -4.0, "fa_b": 20.0, "sa_b": 0.0, "th_f": 24.0, "sh_f": -4.0, "th_b": -18.0, "sh_b": -22.0}
	poses.idle_b = {"hy": 2.0, "t": 7.0, "head": -8.0, "ua_f": 42.0, "fa_f": 162.0, "sa_f": -128.0, "ua_b": -2.0, "fa_b": 22.0, "th_f": 25.0, "sh_f": -5.0, "th_b": -19.0, "sh_b": -22.0}
	poses.walk1 = {"t": 8.0, "ua_f": 40.0, "fa_f": 160.0, "sa_f": -130.0, "ua_b": -14.0, "fa_b": 6.0, "th_f": 34.0, "sh_f": 4.0, "th_b": -26.0, "sh_b": -30.0}
	poses.walk2 = {"t": 8.0, "ua_f": 38.0, "fa_f": 158.0, "sa_f": -132.0, "ua_b": 8.0, "fa_b": 26.0, "th_f": 12.0, "sh_f": -30.0, "th_b": -6.0, "sh_b": -12.0, "hy": -3.0}
	poses.guard = {"t": -4.0, "head": 6.0, "ua_f": 60.0, "fa_f": 150.0, "sa_f": 185.0, "ua_b": 60.0, "fa_b": 140.0, "th_f": 22.0, "sh_f": 8.0, "th_b": -24.0, "sh_b": -24.0, "face": "angry"}
	poses.win = {"t": 0.0, "head": -12.0, "ua_f": 40.0, "fa_f": 160.0, "sa_f": -130.0, "ua_b": 30.0, "fa_b": 120.0, "th_f": 10.0, "sh_f": 0.0, "th_b": -10.0, "sh_b": -6.0, "face": "grin", "hand_b": "open"}
	poses.intro = {"t": 0.0, "head": -4.0, "ua_f": 40.0, "fa_f": 160.0, "sa_f": -130.0, "ua_b": 90.0, "fa_b": 100.0, "th_f": 8.0, "sh_f": 0.0, "th_b": -8.0, "sh_b": -2.0, "face": "closed", "hand_b": "open"}
	poses.room = {"t": 4.0, "head": -10.0, "ua_f": 40.0, "fa_f": 160.0, "sa_f": -130.0, "ua_b": 100.0, "fa_b": 120.0, "hand_b": "open", "face": "closed"}

	var raise := {"t": -12.0, "head": 6.0, "ua_f": 160.0, "fa_f": 200.0, "sa_f": 240.0, "ua_b": 30.0, "fa_b": 90.0, "face": "angry"}
	var cut := {"t": 24.0, "head": -14.0, "ua_f": 95.0, "fa_f": 70.0, "sa_f": 40.0, "ua_b": -20.0, "fa_b": 20.0, "th_f": 46.0, "sh_f": -6.0, "face": "shout"}

	moves.light = {
		"anim": [[4, {"ua_f": 60.0, "fa_f": 120.0, "sa_f": 170.0, "face": "attack"}], [3, {"t": 14.0, "ua_f": 90.0, "fa_f": 88.0, "sa_f": 92.0, "face": "attack"}], [5, {"t": 14.0, "ua_f": 90.0, "fa_f": 88.0, "sa_f": 92.0}], [9, "idle"]],
		"hits": [{"f": [6, 10], "seg": "sword_f", "r": 18.0, "dmg": 44.0, "stun": 14, "bstun": 10, "kb": 4.5, "hs": 6, "spark": "slash", "sfx": "slash_l"}],
		"sfx": [[3, "swing_l"]], "trail": "sword_f", "cancel": true, "chain": ["heavy", "kick"],
	}
	moves.heavy = {
		"anim": [[10, raise], [3, cut], [6, cut], [15, "idle"]],
		"hits": [{"f": [11, 17], "seg": "sword_f", "r": 26.0, "dmg": 110.0, "stun": 22, "bstun": 16, "kb": 7.0, "hs": 12, "spark": "slash", "sfx": "slash_h", "chip": 0.1}],
		"sfx": [[9, "swing_h"]], "trail": "sword_f", "cancel": true,
	}
	moves.kick = {
		"anim": [[5, {"t": -10.0, "th_f": 60.0, "sh_f": 10.0}], [3, {"t": -24.0, "head": 10.0, "th_f": 110.0, "sh_f": 120.0, "face": "attack"}], [5, {"t": -24.0, "head": 10.0, "th_f": 110.0, "sh_f": 120.0}], [11, "idle"]],
		"hits": [{"f": [8, 13], "seg": "foot_f", "r": 20.0, "dmg": 58.0, "stun": 17, "bstun": 12, "kb": 6.0, "hs": 8}],
		"sfx": [[4, "swing_m"]], "trail": "foot_f", "cancel": true,
	}
	moves.c_light = {
		"anim": [[4, {"base": "crouch", "ua_f": 70.0, "fa_f": 90.0, "sa_f": 100.0}], [3, {"base": "crouch", "t": 30.0, "ua_f": 92.0, "fa_f": 90.0, "sa_f": 92.0, "face": "attack"}], [4, {"base": "crouch", "t": 30.0, "ua_f": 92.0, "fa_f": 90.0, "sa_f": 92.0}], [8, "crouch"]],
		"hits": [{"f": [6, 10], "seg": "sword_f", "r": 18.0, "dmg": 40.0, "stun": 13, "bstun": 9, "kb": 4.0, "lvl": "low", "hs": 6, "spark": "slash", "sfx": "slash_l"}],
		"sfx": [[3, "swing_l"]], "trail": "sword_f", "crouch": true, "cancel": true, "chain": ["c_heavy", "c_kick"],
	}
	moves.c_heavy = {
		"anim": [[6, {"base": "crouch", "ua_f": 20.0, "fa_f": 40.0, "sa_f": 20.0}], [4, {"t": -10.0, "head": -20.0, "ua_f": 150.0, "fa_f": 170.0, "sa_f": 175.0, "th_f": 20.0, "sh_f": 0.0, "th_b": -14.0, "sh_b": -10.0, "face": "shout"}],
			[8, {"t": -10.0, "head": -20.0, "ua_f": 152.0, "fa_f": 172.0, "sa_f": 178.0, "th_f": 20.0, "sh_f": 0.0, "th_b": -14.0, "sh_b": -10.0, "face": "shout"}], [14, "crouch"]],
		"hits": [{"f": [8, 16], "seg": "sword_f", "r": 28.0, "dmg": 90.0, "stun": 20, "bstun": 14, "kb": 3.0, "lift": -15.0, "kd": true, "hs": 11, "spark": "slash", "sfx": "slash_h"}],
		"sfx": [[5, "swing_h"]], "trail": "sword_f", "crouch": true, "cancel": true,
	}
	moves.c_kick = {
		"anim": [[5, {"base": "crouch", "t": 34.0}], [3, {"base": "crouch", "t": 36.0, "th_f": 92.0, "sh_f": 92.0, "face": "attack"}], [5, {"base": "crouch", "t": 36.0, "th_f": 92.0, "sh_f": 92.0}], [12, "crouch"]],
		"hits": [{"f": [7, 12], "seg": "foot_f", "r": 18.0, "dmg": 58.0, "stun": 18, "bstun": 12, "kb": 4.0, "lvl": "low", "kd": true, "lift": -6.0, "hs": 8}],
		"sfx": [[4, "swing_m"]], "trail": "foot_f", "crouch": true,
	}
	moves.j_light = {
		"anim": [[3, {"base": "jump", "ua_f": 70.0, "fa_f": 100.0, "sa_f": 110.0}], [3, {"base": "jump", "ua_f": 90.0, "fa_f": 90.0, "sa_f": 70.0, "face": "attack"}], [10, {"base": "jump", "ua_f": 90.0, "fa_f": 90.0, "sa_f": 70.0}], [6, "jump"]],
		"hits": [{"f": [5, 14], "seg": "sword_f", "r": 18.0, "dmg": 44.0, "stun": 15, "bstun": 10, "kb": 4.0, "lvl": "high", "hs": 7, "spark": "slash", "sfx": "slash_l"}],
		"sfx": [[2, "swing_l"]], "trail": "sword_f", "air": true,
	}
	moves.j_heavy = {
		"anim": [[6, {"base": "jump", "ua_f": 170.0, "fa_f": 190.0, "sa_f": 210.0, "face": "angry"}], [3, {"base": "jump", "t": 30.0, "ua_f": 80.0, "fa_f": 50.0, "sa_f": 20.0, "face": "shout"}], [10, {"base": "jump", "t": 30.0, "ua_f": 80.0, "fa_f": 50.0, "sa_f": 20.0}], [6, "jump"]],
		"hits": [{"f": [7, 17], "seg": "sword_f", "r": 24.0, "dmg": 90.0, "stun": 20, "bstun": 14, "kb": 6.0, "lvl": "high", "hs": 10, "spark": "slash", "sfx": "slash_h"}],
		"sfx": [[5, "swing_h"]], "trail": "sword_f", "air": true,
	}
	moves.j_kick = {
		"anim": [[4, {"base": "jump", "th_f": 60.0, "sh_f": 20.0}], [3, {"base": "jump", "t": -10.0, "th_f": 75.0, "sh_f": 70.0, "face": "attack"}], [12, {"base": "jump", "t": -10.0, "th_f": 75.0, "sh_f": 70.0}], [5, "jump"]],
		"hits": [{"f": [6, 18], "seg": "foot_f", "r": 20.0, "dmg": 55.0, "stun": 16, "bstun": 11, "kb": 5.0, "lvl": "high", "hs": 8}],
		"sfx": [[3, "swing_m"]], "trail": "foot_f", "air": true,
	}

	# --- specials
	moves.s1 = {
		"title": "ROOM: AMPUTATE!",
		"anim": [[10, "room"], [6, raise], [4, cut], [12, cut], [12, "idle"]],
		"hits": [{"f": [21, 26], "seg": "pts", "pts": [[160, -160], [330, -160]], "r": 60.0, "dmg": 95.0, "stun": 22, "bstun": 14, "kb": 6.0, "hs": 12, "spark": "slash", "sfx": "slash_h", "chip": 0.12}],
		"fx": [[4, "room", [240, -150]], [21, "slash_x", [250, -160]]], "sfx": [[3, "aura"], [19, "swing_h"]], "trail": "sword_f",
	}
	moves.s1_h = {
		"title": "INJECTION SHOT!",
		"anim": [[12, {"base": "crouch", "t": 20.0, "ua_f": 40.0, "fa_f": 70.0, "sa_f": 90.0, "ua_b": -30.0, "fa_b": 10.0, "face": "closed"}],
			[12, {"t": 40.0, "head": -26.0, "ua_f": 92.0, "fa_f": 90.0, "sa_f": 90.0, "ua_b": -50.0, "fa_b": -30.0, "th_f": 80.0, "sh_f": 0.0, "th_b": -60.0, "sh_b": -70.0, "face": "attack"}],
			[14, {"t": 20.0, "ua_f": 92.0, "fa_f": 90.0, "sa_f": 90.0, "face": "angry"}], [10, "idle"]],
		"hits": [{"f": [13, 22], "seg": "sword_f", "r": 26.0, "dmg": 115.0, "stun": 24, "bstun": 16, "kb": 10.0, "lift": -8.0, "kd": true, "hs": 13, "spark": "slash", "sfx": "slash_h", "chip": 0.1}],
		"vel": [[13, 22.0], [23, 2.0]], "slide": true, "ghost": true, "sfx": [[12, "dash"], [13, "swing_h"]], "trail": "sword_f",
	}
	moves.s2 = {
		"title": "SHAMBLES!",
		"anim": [[10, "room"], [4, {"t": 0.0, "face": "closed"}], [4, cut], [10, cut], [12, "idle"]],
		"hits": [{"f": [15, 21], "seg": "sword_f", "r": 30.0, "dmg": 90.0, "stun": 22, "bstun": 14, "kb": 7.0, "lift": -8.0, "kd": true, "hs": 12, "spark": "slash", "sfx": "slash_h"}],
		"warp": [[12, 90.0]], "invuln": [10, 14], "fx": [[3, "room", [0, -150]]], "sfx": [[3, "aura"], [12, "dash"], [14, "swing_h"]], "trail": "sword_f",
	}
	moves.s3 = {
		"title": "TAKT!",
		"anim": [[8, {"base": "crouch", "ua_b": 60.0, "fa_b": 100.0, "hand_b": "open"}], [6, {"t": -6.0, "head": -18.0, "ua_b": 170.0, "fa_b": 178.0, "hand_b": "open", "face": "shout"}],
			[16, {"t": -6.0, "head": -18.0, "ua_b": 172.0, "fa_b": 179.0, "hand_b": "open", "face": "shout"}], [12, "idle"]],
		"hits": multi(10, 3, 5, {"seg": "pts", "pts": [[230, -300], [230, -20]], "r": 56.0, "dmg": 30.0, "stun": 20, "bstun": 10, "kb": 1.0, "lift": -14.0, "kd": true, "hs": 6, "spark": "heavy", "sfx": "hit_m", "chip": 0.12},
			{"dmg": 45.0, "lift": -17.0, "hs": 11, "sfx": "hit_h"}),
		"invuln": [1, 8], "fx": [[4, "room", [230, -150]], [10, "shockwave", [230, -10]], [10, "dust", [230, 0]]], "sfx": [[3, "aura"], [9, "thud"]],
	}
	var stab := {"t": 40.0, "head": -26.0, "ua_f": 92.0, "fa_f": 90.0, "sa_f": 90.0, "ua_b": -50.0, "fa_b": -30.0, "th_f": 80.0, "sh_f": 0.0, "th_b": -60.0, "sh_b": -70.0, "face": "shout", "fx": "gamma"}
	moves["super"] = {
		"title": "GAMMA KNIFE!",
		"super": true,
		"anim": [[22, {"base": "room", "fx": "gamma"}], [6, {"base": "crouch", "fx": "gamma"}], [6, stab], [22, stab], [14, "idle"]],
		"hits": [{"f": [29, 36], "seg": "sword_f", "r": 40.0, "dmg": 290.0, "stun": 40, "bstun": 22, "kb": 12.0, "lift": -12.0, "kd": true, "hs": 24, "spark": "heavy", "sfx": "hit_h", "chip": 0.25}],
		"warp": [[26, 150.0]], "invuln": [1, 30], "zoom": true, "trail": "sword_f",
		"fx": [[3, "room", [0, -150]], [31, "electric", [160, -150]]], "sfx": [[2, "aura"], [26, "dash"], [28, "swing_h"]], "shake_at": [[31, 12.0]],
	}


func more_moves() -> void:
	moves.s2_h = {
		"title": "COUNTER SHOCK!",
		"anim": [[10, {"t": 10.0, "ua_b": 60.0, "fa_b": 80.0, "hand_b": "open", "face": "closed", "fx": "spark"}], [4, {"t": 26.0, "ua_b": 92.0, "fa_b": 92.0, "ua_f": 30.0, "fa_f": 160.0, "sa_f": -130.0, "hand_b": "open", "th_f": 50.0, "face": "shout", "fx": "spark"}],
			[12, {"t": 26.0, "ua_b": 92.0, "fa_b": 92.0, "ua_f": 30.0, "fa_f": 160.0, "sa_f": -130.0, "hand_b": "open", "th_f": 50.0, "face": "shout"}], [12, "idle"]],
		"hits": [{"f": [11, 16], "seg": "pts", "pts": [[40, -150], [115, -150]], "r": 42.0, "dmg": 100.0, "stun": 40, "bstun": 16, "kb": 4.0, "hs": 18, "spark": "heavy", "sfx": "hit_h", "chip": 0.1}],
		"fx": [[11, "electric", [100, -150]]], "sfx": [[9, "aura"], [11, "clash"]],
	}
	moves.s3_h = {
		"title": "RADIO KNIFE!",
		"anim": [[4, {"base": "crouch", "ua_f": 20.0, "fa_f": 30.0, "sa_f": 10.0, "fx": "spark"}], [5, {"t": -16.0, "head": -24.0, "ua_f": 165.0, "fa_f": 175.0, "sa_f": 180.0, "th_f": 10.0, "sh_f": 0.0, "th_b": -10.0, "sh_b": -6.0, "face": "shout", "fx": "spark"}],
			[12, {"t": -16.0, "head": -24.0, "ua_f": 168.0, "fa_f": 177.0, "sa_f": 182.0, "th_f": 10.0, "sh_f": 0.0, "th_b": -10.0, "sh_b": -6.0, "face": "shout", "fx": "spark"}], [14, "idle"]],
		"hits": [{"f": [5, 15], "seg": "sword_f", "r": 32.0, "dmg": 105.0, "stun": 22, "bstun": 14, "kb": 3.0, "lift": -16.0, "kd": true, "hs": 13, "spark": "slash", "sfx": "slash_h"}],
		"vel": [[5, 3.0, -14.0]], "invuln": [1, 9], "fx": [[6, "electric", [60, -220]]], "sfx": [[4, "swing_h"]], "trail": "sword_f",
	}
	moves.s4 = {
		"title": "MES!",
		"anim": [[6, {"t": 20.0, "ua_b": 80.0, "fa_b": 90.0, "hand_b": "open", "face": "angry"}], [6, {"t": 26.0, "ua_b": 92.0, "fa_b": 92.0, "hand_b": "open", "th_f": 50.0, "face": "attack"}],
			[18, {"t": -6.0, "head": -10.0, "ua_b": 120.0, "fa_b": 160.0, "hand_b": "fist", "face": "grin", "fx": "heart"}], [10, "idle"]],
		"hits": [{"f": [7, 10], "seg": "pts", "pts": [[40, -150], [120, -150]], "r": 44.0, "dmg": 80.0, "stun": 60, "bstun": 0, "kb": 2.0, "hs": 16, "spark": "heavy", "sfx": "hit_h", "throw": true}],
		"vel": [[6, 6.0]], "sfx": [[5, "swing_m"], [9, "aura"]],
	}
	var stab := {"t": 40.0, "head": -26.0, "ua_f": 92.0, "fa_f": 90.0, "sa_f": 90.0, "ua_b": -50.0, "fa_b": -30.0, "th_f": 80.0, "sh_f": 0.0, "th_b": -60.0, "sh_b": -70.0, "face": "shout", "fx": "gamma"}
	moves.super2 = {
		"title": "K-ROOM: PUNCTURE WILLE!",
		"super": true,
		"anim": [[24, {"base": "room", "fx": "gamma"}], [8, {"t": -20.0, "head": 6.0, "ua_f": 175.0, "fa_f": 178.0, "sa_f": 180.0, "ua_b": 170.0, "fa_b": 176.0, "face": "angry", "fx": "gamma"}], [8, stab], [30, stab], [14, "idle"]],
		"hits": multi(33, 8, 3, {"seg": "pts", "pts": [[60, -150], [380, -150]], "r": 46.0, "dmg": 22.0, "stun": 28, "bstun": 9, "kb": 1.0, "hs": 3, "spark": "heavy", "sfx": "hit_m", "chip": 0.2},
			{"dmg": 120.0, "kb": 16.0, "lift": -12.0, "kd": true, "hs": 22, "sfx": "hit_h"}),
		"invuln": [1, 34], "zoom": true, "fx": [[3, "room", [150, -150]], [33, "electric", [200, -150]], [42, "electric", [320, -150]], [54, "shockwave", [260, -150]]],
		"sfx": [[2, "aura"], [32, "swing_h"], [40, "clash"], [54, "hit_h"]], "shake_at": [[54, 12.0]],
	}


# ---------------------------------------------------------------- drawing

func draw_sword(cv: CanvasItem, J: Dictionary, _p: Dictionary, s: String, st: Dictionary) -> void:
	if s != "f":
		return
	var hand: Vector2 = J.hand_f
	var tip: Vector2 = J.tip_f
	var v := (tip - hand).normalized()
	var n := Vector2(-v.y, v.x)
	var start := hand - v * 28.0
	# white grip with black diamonds, square guard and the fluffy tassel of Kikoku
	shape(cv, capsule(start, hand + v * 10.0, 4.0, 4.0, 3), Color("f2efe6"), st, false, 1.6)
	for i in 4:
		var c := start + v * (5.0 + i * 8.5)
		cv.draw_colored_polygon(PackedVector2Array([c - v * 3.0, c + n * 3.0, c + v * 3.0, c - n * 3.0]), fc(Color("1a1a20"), st))
	var g := hand + v * 12.0
	shape(cv, PackedVector2Array([g - n * 9.0 - v * 2.0, g + n * 9.0 - v * 2.0, g + n * 9.0 + v * 2.0, g - n * 9.0 + v * 2.0]), Color("c9a03a"), st, false, 1.4)
	shape(cv, ellipse(start - v * 4.0 + n * 6.0, 8.0, 6.0, 10), Color("f4f2ee"), st, false, 1.4)
	var b0 := g + v * 3.0
	var pts := PackedVector2Array()
	var steps := 8
	for i in steps + 1:
		var u := float(i) / steps
		var w := lerpf(3.4, 0.6, pow(u, 3.0))
		pts.append(b0.lerp(tip, u) + n * (sin(u * PI * 0.9) * 4.0 + w))
	for i in range(steps, -1, -1):
		var u := float(i) / steps
		var w := lerpf(3.4, 0.6, pow(u, 3.0))
		pts.append(b0.lerp(tip, u) + n * (sin(u * PI * 0.9) * 4.0 - w))
	if not Geometry2D.triangulate_polygon(pts).is_empty():
		cv.draw_colored_polygon(pts, fc(Color("d8e0ea"), st))
	outline(cv, pts, 1.4)
	var edge := PackedVector2Array()
	for i in steps + 1:
		var u := float(i) / steps
		edge.append(b0.lerp(tip, u) + n * (sin(u * PI * 0.9) * 4.0 - 1.2))
	cv.draw_polyline(edge, Color(1, 1, 1, 0.9), 1.3, true)


func draw_torso_extra(cv: CanvasItem, _J: Dictionary, _p: Dictionary, st: Dictionary, L: float, ch: float) -> void:
	# Heart Pirates jolly roger on the shirt + high fuzzy collar
	var c := Vector2(9 * ch, -L * 0.6)
	var ink := fc(Color("16161b"), st)
	cv.draw_circle(c, 7.5, ink)
	cv.draw_arc(c, 11.5, 0.0, TAU, 16, ink, 2.2, true)
	for a_deg in [45.0, 135.0, 225.0, 315.0]:
		var a := deg_to_rad(a_deg)
		cv.draw_line(c + Vector2(cos(a) * 8.0, sin(a) * 8.0), c + Vector2(cos(a) * 14.0, sin(a) * 14.0), ink, 2.2, true)
	cv.draw_circle(c + Vector2(-2.5, -1.5), 1.7, fc(col.top, st))
	cv.draw_circle(c + Vector2(2.5, -1.5), 1.7, fc(col.top, st))
	coat_torso(cv, st, L, ch, col.sleeve, Color("e8c14a"))
	# yellow coat emblem on back panel + fuzzy white collar around neck
	var col_pts := PackedVector2Array([Vector2(-15 * ch, -L + 4), Vector2(-19 * ch, -L - 10), Vector2(-6 * ch, -L - 12), Vector2(4 * ch, -L - 8), Vector2(2 * ch, -L + 2)])
	shape(cv, col_pts, Color("f1eee6"), st, true, 1.8)


func draw_back_fx(cv: CanvasItem, J: Dictionary, p: Dictionary, st: Dictionary) -> void:
	if p.get("fx", "") == "gamma":
		var tt: float = st.get("time", 0.0)
		cv.draw_circle(J.neck + Vector2(0, 30), 120.0 + 10.0 * sin(tt * 10.0), Color(0.4, 0.8, 1.0, 0.15))
	coat_tail(cv, J, st, col.sleeve, false, 106.0, 19.0)


func draw_leg_extra(cv: CanvasItem, J: Dictionary, _p: Dictionary, s: String, st: Dictionary) -> void:
	# spotted jeans
	var hip: Vector2 = J.hip
	var kn: Vector2 = J["knee_" + s]
	var ft: Vector2 = J["foot_" + s]
	var spot := fc(Color("162038"), st)
	for u: float in [0.25, 0.52, 0.76]:
		cv.draw_circle(hip.lerp(kn, u) + Vector2(3.0 if u < 0.5 else -2.0, 0), 3.4, spot)
	for u2: float in [0.32, 0.65]:
		cv.draw_circle(kn.lerp(ft, u2) + Vector2(-2.0 if u2 < 0.5 else 2.5, 0), 3.1, spot)
	if s == "f":
		coat_tail(cv, J, st, col.sleeve, true, 98.0, 17.0)


func draw_arm_extra(cv: CanvasItem, J: Dictionary, _p: Dictionary, s: String, st: Dictionary) -> void:
	# fuzzy white coat cuff + DEATH finger tattoos hint on back of hand
	var el: Vector2 = J["elbow_" + s]
	var ha: Vector2 = J["hand_" + s]
	shape(cv, ellipse(el.lerp(ha, 0.82), 11.5, 9.2, 12, (ha - el).angle()), Color("f2efe6"), st, true, 1.6)
	cv.draw_circle(ha, 3.2, fc(Color("16161b"), st))


func draw_hair(cv: CanvasItem, R: float, _p: Dictionary, st: Dictionary) -> void:
	spikes(cv, R * 0.98, 120.0, 250.0, 5, R * 0.3, col.hair, st, 0.4, Vector2(-R * 0.05, 0), 17, -10.0)
	var b := local_pts(Vector2.ZERO, Vector2.RIGHT, Vector2.DOWN, R, [[-0.2, -0.9], [0.7, -0.8], [0.92, -0.42], [0.74, -0.5], [0.6, -0.3], [0.48, -0.52], [0.3, -0.36], [0.16, -0.56], [-0.2, -0.5]])
	shape(cv, b, col.hair, st, true, 2.0)


func draw_face_extra(cv: CanvasItem, R: float, _p: Dictionary, st: Dictionary) -> void:
	var ink := fc(col.hair, st)
	# tired eye bags, sculpted goatee, sideburns and gold earrings
	for e in [EYE_NEAR, EYE_FAR]:
		var c: Vector2 = e * R + Vector2(0, R * 0.36)
		cv.draw_arc(c, R * 0.14, 0.4, PI - 0.4, 6, shadow_of(fc(col.skin, st)).darkened(0.24), 1.5, true)
	var gt := PackedVector2Array([Vector2(R * 0.34, R * 0.96), Vector2(R * 0.48, R * 0.94), Vector2(R * 0.46, R * 1.24), Vector2(R * 0.38, R * 1.24)])
	cv.draw_colored_polygon(gt, ink)
	var sb := PackedVector2Array([Vector2(-R * 0.28, R * 0.12), Vector2(-R * 0.16, R * 0.14), Vector2(-R * 0.14, R * 0.65), Vector2(-R * 0.24, R * 0.62)])
	cv.draw_colored_polygon(sb, ink)
	for i in 2:
		cv.draw_arc(Vector2(-R * 0.5, R * 0.38 + i * R * 0.12), R * 0.075, 0.0, TAU, 8, fc(Color("e8c040"), st), 1.9, true)


func draw_hat(cv: CanvasItem, R: float, _p: Dictionary, st: Dictionary) -> void:
	# white fuzzy Northern-style hat with dark leopard spots and fluffy brim
	var hat := Color("f4f1e8")
	var crown := PackedVector2Array()
	for i in 15:
		var a := PI + PI * float(i) / 14.0
		crown.append(Vector2(-R * 0.05 + cos(a) * R * 1.04, -R * 0.46 + sin(a) * R * 0.96))
	shape(cv, crown, hat, st)
	var spot := fc(Color("3b291e"), st)
	for q in [Vector2(-0.42, -0.92), Vector2(0.18, -1.16), Vector2(0.56, -0.76), Vector2(-0.08, -0.64), Vector2(-0.72, -0.58), Vector2(0.32, -0.62)]:
		cv.draw_circle(q * R, R * 0.105, spot)
	# fuzzy brim with dark spots
	var brim := PackedVector2Array()
	for i in 24:
		var a := TAU * float(i) / 24.0
		var r := 1.0 + (0.12 if i % 2 == 0 else 0.0)
		brim.append(Vector2(-R * 0.05 + cos(a) * R * 1.16 * r, -R * 0.45 + sin(a) * R * 0.23 * r))
	shape(cv, brim, hat, st, true, 2.0)
	for q2 in [Vector2(-0.55, -0.44), Vector2(0.05, -0.42), Vector2(0.58, -0.45)]:
		cv.draw_circle(q2 * R, R * 0.075, spot)


func draw_front_fx(cv: CanvasItem, J: Dictionary, p: Dictionary, st: Dictionary) -> void:
	var fxk: String = p.get("fx", "")
	var tt: float = st.get("time", 0.0)
	if fxk == "gamma" and has_swords:
		# the energy blade glows around Kikoku
		var a: Vector2 = J.hand_f
		var b: Vector2 = J.tip_f
		cv.draw_line(a, b, Color(0.5, 0.9, 1.0, 0.35), 18.0, true)
		cv.draw_line(a, b, Color(0.8, 0.97, 1.0, 0.7), 6.0, true)
	elif fxk == "spark":
		var c: Vector2 = J.hand_b
		var rng := RandomNumberGenerator.new()
		rng.seed = int(tt * 30.0)
		for i in 4:
			var pts := PackedVector2Array([c])
			var ang := rng.randf() * TAU
			for k in 3:
				ang += rng.randf_range(-0.8, 0.8)
				pts.append(pts[pts.size() - 1] + Vector2(cos(ang), sin(ang)) * 12.0)
			cv.draw_polyline(pts, Color(1.0, 0.95, 0.5, 0.9), 2.0, true)
	elif fxk == "heart":
		# the stolen heart in its cube
		var c: Vector2 = J.hand_b + Vector2(0, -26)
		var cube := PackedVector2Array([c + Vector2(-16, -16), c + Vector2(16, -16), c + Vector2(16, 16), c + Vector2(-16, 16)])
		cv.draw_colored_polygon(cube, Color(0.6, 0.85, 1.0, 0.35))
		outline(cv, cube, 2.0, Color(0.6, 0.9, 1.0))
		var beat := 1.0 + 0.15 * sin(tt * 18.0)
		cv.draw_circle(c + Vector2(-4, -3) * beat, 6.0 * beat, Color(0.85, 0.1, 0.15))
		cv.draw_circle(c + Vector2(4, -3) * beat, 6.0 * beat, Color(0.85, 0.1, 0.15))
		cv.draw_colored_polygon(PackedVector2Array([c + Vector2(-10, -1) * beat, c + Vector2(10, -1) * beat, c + Vector2(0, 11) * beat]), Color(0.85, 0.1, 0.15))
