extends CharData
## Jinbe: whale shark fish-man, master of Fish-Man Karate. Slow and huge,
## with heavy palm strikes, water bullets and a command throw.


func setup() -> void:
	id = "jinbe"
	display_name = "JINBE"
	epithet = "Knight of the Sea"
	quote = "Fish-Man Karate moves the water inside you."
	accent = Color("2d6fb8")
	trail_color = Color(0.55, 0.85, 1.0)
	dims.thigh = 60.0
	dims.shin = 58.0
	dims.torso = 92.0
	dims.head = 27.0
	dims.ua = 46.0
	dims.fa = 44.0
	dims.chest = 1.6
	dims.limb = 1.35
	dims.foot = 26.0
	col.skin = Color("6f9fc8")
	col.hair = Color("1c1f2a")
	col.top = Color("33507e")
	col.sleeve = Color("33507e")
	col.pants = Color("2a4268")
	col.shoes = Color("6a4a2c")
	col.sash = Color("e2a23a")
	col.eye = Color("3a2a1a")
	style = {"top": "shirt", "sleeves": "short", "pants": "knee", "feet": "sandal", "cuff": false, "sash_tail": true}
	walk_speed = 3.6
	back_speed = 2.9
	jump_vy = -18.5
	jump_vx = 4.6
	dash_speed = 11.5
	max_hp = 1150.0

	poses.idle = {"t": 6.0, "head": -4.0, "ua_f": 40.0, "fa_f": 120.0, "ua_b": 20.0, "fa_b": 110.0, "th_f": 30.0, "sh_f": -6.0, "th_b": -22.0, "sh_b": -26.0}
	poses.idle_b = {"hy": 3.0, "t": 7.0, "head": -5.0, "ua_f": 42.0, "fa_f": 122.0, "ua_b": 22.0, "fa_b": 112.0, "th_f": 31.0, "sh_f": -7.0, "th_b": -23.0, "sh_b": -26.0}
	poses.walk1 = {"t": 8.0, "ua_f": 40.0, "fa_f": 120.0, "ua_b": 14.0, "fa_b": 100.0, "th_f": 36.0, "sh_f": 2.0, "th_b": -26.0, "sh_b": -30.0}
	poses.walk2 = {"t": 8.0, "ua_f": 38.0, "fa_f": 118.0, "ua_b": 26.0, "fa_b": 116.0, "th_f": 14.0, "sh_f": -26.0, "th_b": -8.0, "sh_b": -14.0, "hy": -3.0}
	poses.guard = {"t": -2.0, "head": 8.0, "ua_f": 50.0, "fa_f": 175.0, "ua_b": 40.0, "fa_b": 170.0, "th_f": 26.0, "sh_f": 6.0, "th_b": -24.0, "sh_b": -24.0, "face": "angry"}
	poses.win = {"t": 0.0, "head": -6.0, "ua_f": 30.0, "fa_f": 110.0, "ua_b": 30.0, "fa_b": 110.0, "hand_f": "open", "th_f": 12.0, "sh_f": 0.0, "th_b": -12.0, "sh_b": -4.0, "face": "closed"}
	poses.intro = {"t": 2.0, "head": -4.0, "ua_f": 20.0, "fa_f": 90.0, "ua_b": 20.0, "fa_b": 100.0, "hand_f": "open", "th_f": 20.0, "sh_f": -6.0, "th_b": -20.0, "sh_b": -14.0, "face": "angry"}
	poses.palm = {"t": 18.0, "head": -10.0, "ua_f": 92.0, "fa_f": 90.0, "ua_b": -30.0, "fa_b": 30.0, "hand_f": "open", "th_f": 50.0, "sh_f": -4.0, "th_b": -30.0, "sh_b": -40.0, "face": "shout"}
	poses.chamber = {"t": -6.0, "head": 4.0, "ua_f": 20.0, "fa_f": 140.0, "ua_b": 50.0, "fa_b": 150.0, "th_f": 34.0, "sh_f": -6.0, "th_b": -26.0, "sh_b": -30.0, "face": "angry", "fx": "water"}

	var punch := {"t": 16.0, "head": -8.0, "ua_f": 92.0, "fa_f": 90.0, "ua_b": -20.0, "fa_b": 40.0, "th_f": 40.0, "sh_f": -4.0, "face": "attack"}
	moves.light = {
		"anim": [[4, {"t": 4.0, "ua_f": 60.0, "fa_f": 120.0}], [3, punch], [4, punch], [10, "idle"]],
		"hits": [{"f": [6, 10], "seg": "hand_f", "r": 22.0, "dmg": 46.0, "stun": 14, "bstun": 10, "kb": 5.0, "hs": 7, "sfx": "hit_l"}],
		"sfx": [[3, "swing_l"]], "trail": "hand_f", "cancel": true, "chain": ["heavy", "kick"],
	}
	moves.heavy = {
		"anim": [[11, "chamber"], [3, _m("palm", {"st_f": 1.1})], [6, "palm"], [15, "idle"]],
		"hits": [{"f": [12, 18], "seg": "arm_f", "r": 28.0, "dmg": 115.0, "stun": 23, "bstun": 17, "kb": 9.0, "hs": 13, "spark": "water", "sfx": "hit_h", "chip": 0.08}],
		"sfx": [[10, "swing_h"]], "trail": "hand_f", "cancel": true, "fx": [[13, "water", [110, -150]]],
	}
	moves.kick = {
		"anim": [[6, {"t": -8.0, "th_f": 60.0, "sh_f": 10.0}], [3, {"t": -20.0, "head": 8.0, "th_f": 100.0, "sh_f": 100.0, "face": "attack"}], [6, {"t": -20.0, "head": 8.0, "th_f": 100.0, "sh_f": 100.0}], [12, "idle"]],
		"hits": [{"f": [9, 15], "seg": "foot_f", "r": 24.0, "dmg": 70.0, "stun": 18, "bstun": 13, "kb": 7.0, "hs": 9}],
		"sfx": [[5, "swing_m"]], "trail": "foot_f", "cancel": true,
	}
	moves.c_light = {
		"anim": [[4, {"base": "crouch", "ua_f": 60.0, "fa_f": 110.0}], [3, {"base": "crouch", "t": 30.0, "ua_f": 92.0, "fa_f": 92.0, "face": "attack"}], [4, {"base": "crouch", "t": 30.0, "ua_f": 92.0, "fa_f": 92.0}], [9, "crouch"]],
		"hits": [{"f": [6, 10], "seg": "hand_f", "r": 22.0, "dmg": 42.0, "stun": 13, "bstun": 9, "kb": 4.0, "lvl": "low", "hs": 6, "sfx": "hit_l"}],
		"sfx": [[3, "swing_l"]], "trail": "hand_f", "crouch": true, "cancel": true, "chain": ["c_heavy", "c_kick"],
	}
	moves.c_heavy = {
		"anim": [[7, {"base": "crouch", "ua_f": 10.0, "fa_f": 40.0}], [4, {"t": -10.0, "head": -20.0, "ua_f": 150.0, "fa_f": 170.0, "th_f": 24.0, "sh_f": 0.0, "th_b": -14.0, "sh_b": -10.0, "face": "shout"}],
			[8, {"t": -10.0, "head": -20.0, "ua_f": 152.0, "fa_f": 172.0, "th_f": 24.0, "sh_f": 0.0, "th_b": -14.0, "sh_b": -10.0, "face": "shout"}], [15, "crouch"]],
		"hits": [{"f": [9, 17], "seg": "arm_f", "r": 30.0, "dmg": 95.0, "stun": 21, "bstun": 15, "kb": 3.0, "lift": -15.0, "kd": true, "hs": 12, "spark": "heavy", "sfx": "hit_h"}],
		"sfx": [[6, "swing_h"]], "trail": "hand_f", "crouch": true, "cancel": true,
	}
	moves.c_kick = {
		"anim": [[6, {"base": "crouch", "t": 34.0}], [3, {"base": "crouch", "t": 36.0, "th_f": 92.0, "sh_f": 92.0, "face": "attack"}], [6, {"base": "crouch", "t": 36.0, "th_f": 92.0, "sh_f": 92.0}], [13, "crouch"]],
		"hits": [{"f": [8, 14], "seg": "foot_f", "r": 22.0, "dmg": 64.0, "stun": 18, "bstun": 12, "kb": 4.0, "lvl": "low", "kd": true, "lift": -6.0, "hs": 9}],
		"sfx": [[4, "swing_m"]], "trail": "foot_f", "crouch": true,
	}
	moves.j_light = {
		"anim": [[3, {"base": "jump", "ua_f": 70.0, "fa_f": 100.0}], [3, {"base": "jump", "ua_f": 110.0, "fa_f": 120.0, "face": "attack"}], [10, {"base": "jump", "ua_f": 110.0, "fa_f": 120.0}], [6, "jump"]],
		"hits": [{"f": [5, 14], "seg": "hand_f", "r": 22.0, "dmg": 46.0, "stun": 15, "bstun": 10, "kb": 4.0, "lvl": "high", "hs": 7, "sfx": "hit_l"}],
		"sfx": [[2, "swing_l"]], "trail": "hand_f", "air": true,
	}
	moves.j_heavy = {
		"anim": [[6, {"base": "jump", "ua_f": 170.0, "fa_f": 190.0, "face": "angry"}], [3, {"base": "jump", "t": 30.0, "ua_f": 70.0, "fa_f": 40.0, "face": "shout"}], [10, {"base": "jump", "t": 30.0, "ua_f": 70.0, "fa_f": 40.0}], [6, "jump"]],
		"hits": [{"f": [7, 17], "seg": "arm_f", "r": 28.0, "dmg": 96.0, "stun": 20, "bstun": 14, "kb": 6.0, "lvl": "high", "hs": 11, "spark": "heavy", "sfx": "hit_h"}],
		"sfx": [[5, "swing_h"]], "trail": "hand_f", "air": true,
	}
	moves.j_kick = {
		"anim": [[4, {"base": "jump", "th_f": 60.0, "sh_f": 20.0}], [3, {"base": "jump", "t": -10.0, "th_f": 75.0, "sh_f": 70.0, "face": "attack"}], [12, {"base": "jump", "t": -10.0, "th_f": 75.0, "sh_f": 70.0}], [5, "jump"]],
		"hits": [{"f": [6, 18], "seg": "foot_f", "r": 24.0, "dmg": 62.0, "stun": 16, "bstun": 11, "kb": 5.0, "lvl": "high", "hs": 8}],
		"sfx": [[3, "swing_m"]], "trail": "foot_f", "air": true,
	}
	moves.throw = {
		"title": "THROW!",
		"anim": [[4, {"t": 20.0, "ua_f": 80.0, "fa_f": 90.0, "ua_b": 70.0, "fa_b": 85.0, "hand_f": "open", "hand_b": "open", "face": "angry"}],
			[10, {"t": -30.0, "head": 14.0, "ua_f": 165.0, "fa_f": 175.0, "ua_b": 155.0, "fa_b": 168.0, "th_f": 40.0, "sh_f": 10.0, "th_b": -30.0, "sh_b": -30.0, "face": "shout"}],
			[8, {"t": 34.0, "head": -10.0, "ua_f": 60.0, "fa_f": 50.0, "ua_b": 50.0, "fa_b": 40.0, "th_f": 50.0, "sh_f": 0.0, "face": "shout"}], [12, "idle"]],
		"hits": [{"f": [3, 6], "seg": "pts", "pts": [[30, -150], [120, -150]], "r": 50.0, "dmg": 125.0, "stun": 32, "bstun": 0, "kb": 7.0, "lift": -17.0, "kd": true, "hs": 16, "spark": "heavy", "sfx": "hit_h", "throw": true}],
		"sfx": [[2, "swing_m"], [16, "thud"]], "shake_at": [[18, 8.0]], "fx": [[18, "dust", [100, 0]]],
	}

	# --- specials
	moves.s1 = {
		"title": "GOSENMAIGAWARA SEIKEN!",
		"anim": [[12, "chamber"], [3, _m("palm", {"st_f": 1.1})], [12, "palm"], [12, "idle"]],
		"hits": [{"f": [13, 18], "seg": "pts", "pts": [[60, -150], [170, -150]], "r": 56.0, "dmg": 125.0, "stun": 26, "bstun": 18, "kb": 14.0, "lift": -6.0, "kd": true, "hs": 16, "spark": "water", "sfx": "hit_h", "chip": 0.15}],
		"fx": [[13, "shockwave", [130, -150]], [13, "water", [120, -150]]], "sfx": [[11, "swing_h"], [13, "splash"]], "shake_at": [[13, 8.0]],
	}
	var flick := {"t": 10.0, "head": -6.0, "ua_f": 100.0, "fa_f": 70.0, "ua_b": -20.0, "fa_b": 40.0, "hand_f": "open", "th_f": 36.0, "face": "attack"}
	var drops := []
	for k in 3:
		drops.append([13 + k * 3, {"type": "water", "pos": [100, -170 + k * 18], "vel": [16.0, -0.6 + k * 0.6], "r": 13.0, "life": 60,
			"hit": {"dmg": 34.0, "stun": 16, "bstun": 9, "kb": 3.0, "hs": 5, "spark": "water", "sfx": "hit_m", "chip": 0.12}}])
	moves.s1_h = {
		"title": "UCHIMIZU!",
		"anim": [[11, {"t": -10.0, "ua_f": 20.0, "fa_f": 160.0, "ua_b": 30.0, "fa_b": 100.0, "hand_f": "open", "face": "angry", "fx": "water"}], [3, flick], [14, flick], [10, "idle"]],
		"proj": drops, "sfx": [[12, "splash"], [15, "swing_l"], [18, "swing_l"]],
	}
	moves.s2 = {
		"title": "SAMEGAWARA SEIKEN!",
		"anim": [[10, {"base": "crouch", "t": 30.0, "ua_f": 30.0, "fa_f": 120.0, "face": "angry", "fx": "water"}], [10, _m("palm", {"t": 34.0, "head": -24.0, "st_f": 1.1})], [8, "palm"], [12, "idle"]],
		"hits": [{"f": [11, 20], "seg": "arm_f", "r": 32.0, "dmg": 120.0, "stun": 24, "bstun": 16, "kb": 12.0, "lift": -8.0, "kd": true, "hs": 14, "spark": "water", "sfx": "hit_h", "chip": 0.12}],
		"vel": [[11, 17.0], [21, 2.0]], "slide": true, "fx": [[12, "water", [60, -150]]], "sfx": [[10, "dash"], [12, "splash"]], "trail": "hand_f",
	}
	var rise := {"t": -12.0, "head": -22.0, "ua_f": 170.0, "fa_f": 176.0, "ua_b": -30.0, "fa_b": 20.0, "th_f": 20.0, "sh_f": 0.0, "th_b": -10.0, "sh_b": -10.0, "face": "shout", "fx": "water"}
	moves.s3 = {
		"title": "YARIGAWARA!",
		"anim": [[4, {"base": "crouch", "ua_f": 20.0, "fa_f": 40.0}], [5, rise], [14, rise], [16, "idle"]],
		"hits": [{"f": [5, 14], "seg": "arm_f", "r": 32.0, "dmg": 115.0, "stun": 22, "bstun": 15, "kb": 3.0, "lift": -17.0, "kd": true, "hs": 13, "spark": "water", "sfx": "hit_h"}],
		"vel": [[5, 3.0, -15.0]], "invuln": [1, 8], "fx": [[5, "water", [40, -220]]], "sfx": [[4, "swing_h"], [5, "splash"]], "trail": "hand_f",
	}
	var both := {"t": 22.0, "head": -10.0, "ua_f": 92.0, "fa_f": 90.0, "ua_b": 88.0, "fa_b": 86.0, "hand_f": "open", "hand_b": "open", "th_f": 54.0, "sh_f": -4.0, "th_b": -34.0, "sh_b": -44.0, "face": "shout", "fx": "water"}
	moves["super"] = {
		"title": "BURAIKAN!",
		"super": true,
		"anim": [[26, {"base": "chamber", "t": -14.0, "ua_b": 70.0, "fa_b": 160.0}], [4, both], [22, both], [14, "idle"]],
		"proj": [[30, {"type": "water", "pos": [140, -150], "vel": [9, 0], "r": 70.0, "size": 1.6, "life": 90, "hp": 8, "hits": 5, "every": 6,
			"hit": {"dmg": 52.0, "stun": 26, "bstun": 12, "kb": 4.0, "lift": -6.0, "kd": true, "hs": 9, "spark": "water", "sfx": "hit_h", "chip": 0.2}}]],
		"hits": [{"f": [30, 34], "seg": "pts", "pts": [[60, -150], [160, -150]], "r": 60.0, "dmg": 60.0, "stun": 30, "bstun": 14, "kb": 2.0, "hs": 12, "spark": "water", "sfx": "hit_h"}],
		"invuln": [1, 30], "zoom": true, "fx": [[30, "shockwave", [150, -150]], [30, "water", [150, -150]]],
		"sfx": [[2, "aura"], [29, "splash"], [30, "hit_h"]], "shake_at": [[30, 14.0]],
	}


func more_moves() -> void:
	moves.s2_h = {
		"title": "MIZU GOKORO!",
		"anim": [[14, {"base": "chamber", "ua_b": 80.0, "fa_b": 140.0, "hand_b": "open"}], [4, {"base": "palm", "ua_b": 88.0, "fa_b": 86.0, "hand_b": "open"}], [12, "palm"], [10, "idle"]],
		"proj": [[16, {"type": "water", "pos": [120, -150], "vel": [5.5, 0], "r": 40.0, "size": 1.2, "life": 120, "hp": 3, "hits": 2, "every": 10,
			"hit": {"dmg": 55.0, "stun": 22, "bstun": 12, "kb": 6.0, "hs": 9, "spark": "water", "sfx": "hit_h", "chip": 0.12}}]],
		"sfx": [[6, "aura"], [16, "splash"]],
	}
	var up := {"t": -6.0, "head": -18.0, "ua_f": 170.0, "fa_f": 176.0, "ua_b": 165.0, "fa_b": 172.0, "hand_f": "open", "hand_b": "open", "th_f": 26.0, "sh_f": 0.0, "th_b": -20.0, "sh_b": -10.0, "face": "shout", "fx": "water"}
	moves.s3_h = {
		"title": "KAIRYU SEIKEN: WATER PILLAR!",
		"anim": [[8, {"base": "crouch", "hand_f": "open", "hand_b": "open", "fx": "water"}], [5, up], [20, up], [14, "idle"]],
		"hits": multi(10, 4, 5, {"seg": "pts", "pts": [[90, -330], [90, -20]], "r": 64.0, "dmg": 28.0, "stun": 20, "bstun": 9, "kb": 1.5, "lift": -12.0, "kd": true, "hs": 5, "spark": "water", "sfx": "hit_m", "chip": 0.15},
			{"dmg": 46.0, "lift": -15.0, "kb": 6.0, "hs": 11, "sfx": "hit_h"}),
		"invuln": [1, 12], "fx": [[10, "water", [90, -20]], [14, "water", [90, -120]], [18, "water", [90, -220]], [22, "water", [90, -310]]],
		"sfx": [[9, "splash"], [17, "splash"]],
	}
	var grab := {"t": 24.0, "ua_f": 86.0, "fa_f": 92.0, "ua_b": 80.0, "fa_b": 88.0, "hand_f": "open", "hand_b": "open", "th_f": 46.0, "face": "angry"}
	var heave := {"t": -34.0, "head": 16.0, "ua_f": 170.0, "fa_f": 180.0, "ua_b": 165.0, "fa_b": 176.0, "th_f": 30.0, "sh_f": 10.0, "th_b": -30.0, "sh_b": -30.0, "face": "shout", "fx": "water"}
	var slam := {"t": 40.0, "head": -12.0, "ua_f": 60.0, "fa_f": 40.0, "ua_b": 50.0, "fa_b": 30.0, "th_f": 60.0, "sh_f": 0.0, "th_b": -30.0, "sh_b": -50.0, "face": "shout"}
	moves.s4 = {
		"title": "KAIRYU IPPON ZEOI!",
		"anim": [[6, grab], [4, grab], [10, heave], [6, slam], [16, slam], [12, "idle"]],
		"hits": [{"f": [7, 10], "seg": "pts", "pts": [[40, -150], [140, -150]], "r": 52.0, "dmg": 190.0, "stun": 40, "bstun": 0, "kb": 4.0, "lift": -20.0, "kd": true, "hs": 22, "spark": "water", "sfx": "hit_h", "throw": true}],
		"vel": [[3, 5.0]], "fx": [[22, "water", [110, -20]], [22, "shockwave", [110, -10]]], "sfx": [[6, "swing_m"], [12, "splash"], [22, "thud"]], "shake_at": [[22, 12.0]],
	}
	var shots := []
	var i := 0
	for v in [[19, -1.0], [20, 0.4], [18, -2.0], [21, 1.0], [19, -0.4], [20, -1.4], [18, 0.8], [22, 0.0]]:
		shots.append([18 + i * 3, {"type": "water", "pos": [100, -150 - (i % 3) * 22], "vel": v, "r": 14.0, "life": 70,
			"hit": {"dmg": 30.0, "stun": 24, "bstun": 8, "kb": 2.0, "hs": 5, "spark": "water", "sfx": "hit_m", "chip": 0.2}}])
		i += 1
	shots[shots.size() - 1][1]["r"] = 30.0
	shots[shots.size() - 1][1]["hit"] = {"dmg": 90.0, "stun": 30, "bstun": 14, "kb": 12.0, "lift": -12.0, "kd": true, "hs": 18, "spark": "water", "sfx": "hit_h", "chip": 0.2}
	var flick := {"t": 14.0, "head": -10.0, "ua_f": 100.0, "fa_f": 70.0, "ua_b": 100.0, "fa_b": 80.0, "hand_f": "open", "hand_b": "open", "th_f": 40.0, "face": "shout", "fx": "water"}
	var flick2 := {"t": 14.0, "head": -10.0, "ua_f": 80.0, "fa_f": 110.0, "ua_b": 110.0, "fa_b": 60.0, "hand_f": "open", "hand_b": "open", "th_f": 40.0, "face": "shout", "fx": "water"}
	moves.super2 = {
		"title": "MURASAME!",
		"super": true,
		"anim": [[16, {"base": "chamber", "hand_f": "open", "hand_b": "open"}], [3, flick], [3, flick2], [3, flick], [3, flick2], [3, flick], [3, flick2], [3, flick], [6, flick2], [14, "idle"]],
		"proj": shots, "invuln": [1, 18], "zoom": true, "sfx": [[2, "aura"], [17, "splash"], [26, "splash"], [35, "splash"]],
	}


static func _m(base, extra: Dictionary) -> Dictionary:
	var d := {"base": base}
	d.merge(extra, true)
	return d


# ---------------------------------------------------------------- drawing

func draw_torso_extra(cv: CanvasItem, _J: Dictionary, _p: Dictionary, st: Dictionary, L: float, ch: float) -> void:
	# kimono: a deep V showing the chest, a light trim and a wave crest on the chest
	var v := PackedVector2Array([Vector2(-4 * ch, -L - 2), Vector2(14 * ch, -L - 2.5), Vector2(6 * ch, -L * 0.42)])
	shape(cv, v, col.skin, st, true, 1.8)
	var trim := fc(Color("c9d7ea"), st)
	cv.draw_line(Vector2(-4 * ch, -L - 2), Vector2(6 * ch, -L * 0.42), trim, 3.0, true)
	cv.draw_line(Vector2(14 * ch, -L - 2.5), Vector2(6 * ch, -L * 0.42), trim, 3.0, true)
	var line := shadow_of(fc(col.top, st)).darkened(0.15)
	for k in 3:
		var x := (-12.0 + k * 9.0) * ch
		cv.draw_line(Vector2(x, -L * 0.3), Vector2(x + 2.0 * ch, -L * 0.7), Color(line, 0.6), 1.4, true)
	var c := Vector2(-9 * ch, -L * 0.62)
	cv.draw_arc(c, 7.0, PI * 0.9, PI * 2.2, 10, trim, 2.0, true)
	cv.draw_arc(c + Vector2(4, 2), 3.5, PI, PI * 2.2, 8, trim, 1.6, true)


func draw_face_extra(cv: CanvasItem, R: float, p: Dictionary, st: Dictionary) -> void:
	var face: String = p.get("face", "normal")
	var skin := fc(col.skin, st)
	var ink := shadow_of(skin).darkened(0.35)
	# gill slits on the cheek, thick lips and two lower fangs
	for k in 3:
		var a := Vector2(-R * 0.18 + k * R * 0.07, R * 0.42)
		cv.draw_line(a, a + Vector2(R * 0.04, R * 0.2), ink, 1.6, true)
	var m := MOUTH * R
	if face in ["normal", "angry", "closed", "grin"]:
		cv.draw_line(m + Vector2(-R * 0.22, R * 0.07), m + Vector2(R * 0.18, R * 0.05), Color(ink, 0.7), 2.4, true)
	for x in [-0.14, 0.1]:
		var b := m + Vector2(R * x, R * 0.04)
		cv.draw_colored_polygon(PackedVector2Array([b, b + Vector2(R * 0.08, 0), b + Vector2(R * 0.03, -R * 0.14)]), Color.WHITE)


func draw_hair(cv: CanvasItem, R: float, _p: Dictionary, st: Dictionary) -> void:
	# slicked back hair with a samurai topknot
	var cap := PackedVector2Array()
	for i in 13:
		var a := deg_to_rad(lerpf(140.0, 320.0, float(i) / 12.0))
		cap.append(Vector2(cos(a), sin(a)) * R * 1.06)
	cap.append_array(local_pts(Vector2.ZERO, Vector2.RIGHT, Vector2.DOWN, R, [[0.7, -0.66], [0.3, -0.58], [-0.1, -0.5], [-0.4, -0.2], [-0.5, 0.3], [-0.9, 0.3]]))
	shape(cv, cap, col.hair, st, true, 2.2)
	var sheen := fc(col.hair, st).lightened(0.3)
	for k in 3:
		cv.draw_arc(Vector2(-R * 0.1, -R * 0.1), R * (0.8 + k * 0.08), PI + 0.4 + k * 0.1, PI + 1.3 + k * 0.1, 6, sheen, 1.4, true)
	var knot := local_pts(Vector2.ZERO, Vector2.RIGHT, Vector2.DOWN, R, [[-0.6, -0.9], [-0.2, -1.05], [0.1, -1.3], [0.24, -1.2], [0.0, -1.0], [-0.5, -0.78]])
	shape(cv, knot, col.hair, st, true, 2.0)
	cv.draw_line(Vector2(-R * 0.2, -R * 1.1), Vector2(-R * 0.06, -R * 0.92), fc(Color("e2a23a"), st), 3.0, true)


func draw_brow(cv: CanvasItem, eye: Vector2, R: float, tilt: float, st: Dictionary) -> void:
	# heavy, stern brows
	var k := _squash
	var inner := eye + Vector2(R * 0.26 * k, -R * 0.36 + tilt)
	var outer := eye + Vector2(-R * 0.26 * k, -R * 0.44 - tilt * 0.3)
	var d := (inner - outer).normalized()
	var n := Vector2(-d.y, d.x)
	var pts := PackedVector2Array([outer + n * 2.0, outer.lerp(inner, 0.5) - n * 4.4, inner - n * 3.6, inner + n * 2.4, outer.lerp(inner, 0.5) + n * 2.6])
	if not Geometry2D.triangulate_polygon(pts).is_empty():
		cv.draw_colored_polygon(pts, fc(col.hair, st))


func draw_front_fx(cv: CanvasItem, J: Dictionary, p: Dictionary, st: Dictionary) -> void:
	if p.get("fx", "") != "water":
		return
	# water swirls around the hands
	var tt: float = st.get("time", 0.0)
	for h in [J.hand_f, J.hand_b]:
		var c: Vector2 = h
		cv.draw_circle(c, 22.0, Color(0.4, 0.7, 1.0, 0.25))
		for k in 3:
			var a := tt * 8.0 + k * TAU / 3.0
			cv.draw_arc(c, 16.0 + k * 4.0, a, a + 2.0, 8, Color(0.75, 0.9, 1.0, 0.8 - k * 0.2), 2.4, true)


func head_pts(R: float) -> PackedVector2Array:
	# broad, square fish-man jaw
	var pts := super(R)
	for i in pts.size():
		var q := pts[i]
		pts[i] = Vector2(q.x * 1.12, q.y if q.y < 0.0 else q.y * 1.08)
	return pts


func draw_eye(cv: CanvasItem, eye: Vector2, R: float, face: String, st: Dictionary) -> void:
	# small, stern eyes under heavy brows
	var w := R * 0.2 * _squash
	var h := R * 0.13
	var lid := 0.35 if face in ["angry", "shout", "attack"] else 0.0
	var sc := PackedVector2Array()
	for i in 14:
		var a := TAU * float(i) / 14.0
		var y := sin(a) * h
		if y < 0.0:
			y *= 1.0 - lid * (0.6 + 0.4 * cos(a))
		sc.append(eye + Vector2(cos(a) * w, y))
	cv.draw_colored_polygon(sc, fc(Color(0.96, 0.95, 0.9), st))
	_fill(cv, Geometry2D.intersect_polygons(ellipse(eye + Vector2(w * 0.3, 0), h * 0.85, h * 0.9, 10), sc), Color(0.08, 0.06, 0.05))
	cv.draw_circle(eye + Vector2(w * 0.42, -h * 0.3), R * 0.04, Color.WHITE)
	cv.draw_polyline(PackedVector2Array([sc[7], sc[9], sc[11], sc[13], sc[0]]), OUTLINE, 2.6, true)
