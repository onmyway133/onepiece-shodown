extends CharData
## Dracule Mihawk: the world's strongest swordsman. Slow, huge reach with the
## black blade Yoru, flying black slashes and a counter stance.


func setup() -> void:
	id = "mihawk"
	display_name = "MIHAWK"
	epithet = "Hawk-Eyes"
	quote = "Know the weight of the world's strongest."
	accent = Color("2f6b45")
	trail_color = Color(0.55, 1.0, 0.7)
	has_swords = true
	ai_zoner = true
	dims.thigh = 60.0
	dims.shin = 62.0
	dims.torso = 84.0
	dims.head = 23.0
	dims.ua = 44.0
	dims.fa = 42.0
	dims.chest = 1.3
	dims.limb = 1.05
	dims.sword = 150.0
	col.skin = Color("e6b48a")
	col.hair = Color("1b1b1d")
	col.top = Color("1e1b22")
	col.sleeve = Color("1e1b22")
	col.pants = Color("c7c0d9")
	col.shoes = Color("2a1f1a")
	col.eye = Color("e8b820")
	style = {"top": "vest", "sleeves": "long", "pants": "long", "feet": "boot", "cuff": false}
	walk_speed = 3.8
	back_speed = 3.0
	dash_speed = 12.0
	max_hp = 1020.0

	poses.idle = {"t": 6.0, "head": -6.0, "ua_f": 20.0, "fa_f": 60.0, "sa_f": 35.0, "ua_b": -6.0, "fa_b": 10.0, "sa_b": 0.0, "th_f": 24.0, "sh_f": -4.0, "th_b": -18.0, "sh_b": -22.0}
	poses.idle_b = {"hy": 2.0, "t": 7.0, "head": -7.0, "ua_f": 22.0, "fa_f": 62.0, "sa_f": 37.0, "ua_b": -4.0, "fa_b": 12.0, "sa_b": 0.0, "th_f": 25.0, "sh_f": -5.0, "th_b": -19.0, "sh_b": -22.0}
	poses.walk1 = {"t": 8.0, "ua_f": 24.0, "fa_f": 64.0, "sa_f": 40.0, "ua_b": -14.0, "fa_b": 0.0, "th_f": 34.0, "sh_f": 4.0, "th_b": -26.0, "sh_b": -30.0}
	poses.walk2 = {"t": 8.0, "ua_f": 18.0, "fa_f": 58.0, "sa_f": 34.0, "ua_b": 6.0, "fa_b": 20.0, "th_f": 12.0, "sh_f": -30.0, "th_b": -6.0, "sh_b": -12.0, "hy": -3.0}
	poses.guard = {"t": -4.0, "head": 6.0, "ua_f": 60.0, "fa_f": 150.0, "sa_f": 185.0, "ua_b": 70.0, "fa_b": 140.0, "sa_b": 0.0, "th_f": 22.0, "sh_f": 8.0, "th_b": -24.0, "sh_b": -24.0, "face": "angry"}
	poses.win = {"t": 0.0, "head": -10.0, "ua_f": 10.0, "fa_f": 30.0, "sa_f": 5.0, "ua_b": 30.0, "fa_b": 120.0, "th_f": 10.0, "sh_f": 0.0, "th_b": -10.0, "sh_b": -6.0, "face": "closed"}
	poses.intro = {"t": 0.0, "head": -4.0, "ua_f": 170.0, "fa_f": 175.0, "sa_f": 140.0, "ua_b": -6.0, "fa_b": 10.0, "th_f": 8.0, "sh_f": 0.0, "th_b": -8.0, "sh_b": -2.0, "face": "closed"}

	var raise := {"t": -14.0, "head": 6.0, "ua_f": 160.0, "fa_f": 200.0, "sa_f": 240.0, "ua_b": 150.0, "fa_b": 190.0, "face": "angry"}
	var cut := {"t": 26.0, "head": -14.0, "ua_f": 95.0, "fa_f": 70.0, "sa_f": 40.0, "ua_b": 85.0, "fa_b": 60.0, "th_f": 50.0, "sh_f": -6.0, "face": "shout"}

	moves.light = {
		"anim": [[4, {"ua_f": 60.0, "fa_f": 100.0, "sa_f": 160.0, "face": "attack"}], [3, {"t": 14.0, "ua_f": 90.0, "fa_f": 88.0, "sa_f": 92.0, "face": "attack"}], [5, {"t": 14.0, "ua_f": 90.0, "fa_f": 88.0, "sa_f": 92.0}], [10, "idle"]],
		"hits": [{"f": [6, 10], "seg": "sword_f", "r": 20.0, "dmg": 48.0, "stun": 14, "bstun": 10, "kb": 5.0, "hs": 7, "spark": "slash", "sfx": "slash_l"}],
		"sfx": [[3, "swing_l"]], "trail": "sword_f", "cancel": true, "chain": ["heavy", "kick"],
	}
	moves.heavy = {
		"anim": [[12, raise], [3, cut], [6, cut], [16, "idle"]],
		"hits": [{"f": [13, 19], "seg": "sword_f", "r": 30.0, "dmg": 130.0, "stun": 24, "bstun": 18, "kb": 8.0, "hs": 13, "spark": "slash", "sfx": "slash_h", "chip": 0.1}],
		"sfx": [[11, "swing_h"]], "trail": "sword_f", "cancel": true,
	}
	moves.kick = {
		"anim": [[6, {"t": -10.0, "th_f": 60.0, "sh_f": 10.0}], [3, {"t": -22.0, "head": 10.0, "th_f": 100.0, "sh_f": 96.0, "face": "attack"}], [5, {"t": -22.0, "head": 10.0, "th_f": 100.0, "sh_f": 96.0}], [12, "idle"]],
		"hits": [{"f": [9, 14], "seg": "foot_f", "r": 20.0, "dmg": 60.0, "stun": 17, "bstun": 12, "kb": 6.0, "hs": 8}],
		"sfx": [[5, "swing_m"]], "trail": "foot_f", "cancel": true,
	}
	moves.c_light = {
		"anim": [[4, {"base": "crouch", "ua_f": 70.0, "fa_f": 90.0, "sa_f": 100.0}], [3, {"base": "crouch", "t": 30.0, "ua_f": 92.0, "fa_f": 90.0, "sa_f": 92.0, "face": "attack"}], [4, {"base": "crouch", "t": 30.0, "ua_f": 92.0, "fa_f": 90.0, "sa_f": 92.0}], [9, "crouch"]],
		"hits": [{"f": [6, 10], "seg": "sword_f", "r": 20.0, "dmg": 42.0, "stun": 13, "bstun": 9, "kb": 4.0, "lvl": "low", "hs": 6, "spark": "slash", "sfx": "slash_l"}],
		"sfx": [[3, "swing_l"]], "trail": "sword_f", "crouch": true, "cancel": true, "chain": ["c_heavy", "c_kick"],
	}
	moves.c_heavy = {
		"anim": [[6, {"base": "crouch", "ua_f": 20.0, "fa_f": 40.0, "sa_f": 20.0}], [4, {"t": -10.0, "head": -20.0, "ua_f": 150.0, "fa_f": 170.0, "sa_f": 175.0, "th_f": 20.0, "sh_f": 0.0, "th_b": -14.0, "sh_b": -10.0, "face": "shout"}],
			[8, {"t": -10.0, "head": -20.0, "ua_f": 152.0, "fa_f": 172.0, "sa_f": 178.0, "th_f": 20.0, "sh_f": 0.0, "th_b": -14.0, "sh_b": -10.0, "face": "shout"}], [14, "crouch"]],
		"hits": [{"f": [8, 16], "seg": "sword_f", "r": 30.0, "dmg": 95.0, "stun": 20, "bstun": 14, "kb": 3.0, "lift": -15.0, "kd": true, "hs": 11, "spark": "slash", "sfx": "slash_h"}],
		"sfx": [[5, "swing_h"]], "trail": "sword_f", "crouch": true, "cancel": true,
	}
	moves.c_kick = {
		"anim": [[5, {"base": "crouch", "t": 34.0}], [3, {"base": "crouch", "t": 36.0, "th_f": 92.0, "sh_f": 92.0, "face": "attack"}], [5, {"base": "crouch", "t": 36.0, "th_f": 92.0, "sh_f": 92.0}], [12, "crouch"]],
		"hits": [{"f": [7, 12], "seg": "foot_f", "r": 18.0, "dmg": 60.0, "stun": 18, "bstun": 12, "kb": 4.0, "lvl": "low", "kd": true, "lift": -6.0, "hs": 8}],
		"sfx": [[4, "swing_m"]], "trail": "foot_f", "crouch": true,
	}
	moves.j_light = {
		"anim": [[3, {"base": "jump", "ua_f": 70.0, "fa_f": 100.0, "sa_f": 110.0}], [3, {"base": "jump", "ua_f": 90.0, "fa_f": 90.0, "sa_f": 70.0, "face": "attack"}], [10, {"base": "jump", "ua_f": 90.0, "fa_f": 90.0, "sa_f": 70.0}], [6, "jump"]],
		"hits": [{"f": [5, 14], "seg": "sword_f", "r": 20.0, "dmg": 46.0, "stun": 15, "bstun": 10, "kb": 4.0, "lvl": "high", "hs": 7, "spark": "slash", "sfx": "slash_l"}],
		"sfx": [[2, "swing_l"]], "trail": "sword_f", "air": true,
	}
	moves.j_heavy = {
		"anim": [[6, {"base": "jump", "ua_f": 170.0, "fa_f": 190.0, "sa_f": 210.0, "face": "angry"}], [3, {"base": "jump", "t": 30.0, "ua_f": 80.0, "fa_f": 50.0, "sa_f": 20.0, "face": "shout"}], [10, {"base": "jump", "t": 30.0, "ua_f": 80.0, "fa_f": 50.0, "sa_f": 20.0}], [6, "jump"]],
		"hits": [{"f": [7, 17], "seg": "sword_f", "r": 26.0, "dmg": 95.0, "stun": 20, "bstun": 14, "kb": 6.0, "lvl": "high", "hs": 11, "spark": "slash", "sfx": "slash_h"}],
		"sfx": [[5, "swing_h"]], "trail": "sword_f", "air": true,
	}
	moves.j_kick = {
		"anim": [[4, {"base": "jump", "th_f": 60.0, "sh_f": 20.0}], [3, {"base": "jump", "t": -10.0, "th_f": 75.0, "sh_f": 70.0, "face": "attack"}], [12, {"base": "jump", "t": -10.0, "th_f": 75.0, "sh_f": 70.0}], [5, "jump"]],
		"hits": [{"f": [6, 18], "seg": "foot_f", "r": 20.0, "dmg": 55.0, "stun": 16, "bstun": 11, "kb": 5.0, "lvl": "high", "hs": 8}],
		"sfx": [[3, "swing_m"]], "trail": "foot_f", "air": true,
	}

	# --- specials
	moves.s1 = {
		"title": "Kokuto: YORU!",
		"anim": [[14, raise], [4, cut], [10, cut], [14, "idle"]],
		"proj": [[16, {"type": "black_slash", "pos": [120, -150], "vel": [10, 0], "r": 46.0, "life": 90,
			"hit": {"dmg": 90.0, "stun": 20, "bstun": 16, "kb": 7.0, "hs": 10, "spark": "slash", "sfx": "slash_h", "chip": 0.12}}]],
		"sfx": [[14, "swing_h"], [15, "wind"]], "trail": "sword_f",
	}
	moves.s1_h = {
		"title": "Kokuto: KUROTOGA!",
		"anim": [[22, raise], [4, cut], [12, cut], [16, "idle"]],
		"proj": [[24, {"type": "black_slash", "pos": [130, -160], "vel": [7, 0], "r": 64.0, "size": 1.5, "life": 120, "hp": 3, "hits": 3, "every": 6,
			"hit": {"dmg": 50.0, "stun": 20, "bstun": 12, "kb": 4.0, "hs": 7, "spark": "slash", "sfx": "slash_l", "chip": 0.14}}]],
		"sfx": [[22, "swing_h"], [23, "wind"]], "trail": "sword_f", "shake_at": [[24, 5.0]],
	}
	var lunge := {"t": 34.0, "head": -20.0, "ua_f": 95.0, "fa_f": 92.0, "sa_f": 92.0, "ua_b": -40.0, "fa_b": -20.0, "th_f": 80.0, "sh_f": 0.0, "th_b": -60.0, "sh_b": -70.0, "face": "attack"}
	moves.s2 = {
		"title": "Ittoryu: FLASH STEP!",
		"anim": [[10, {"t": 20.0, "head": -10.0, "ua_f": 30.0, "fa_f": 50.0, "sa_f": 250.0, "th_f": 70.0, "sh_f": 0.0, "th_b": -40.0, "sh_b": -40.0, "face": "closed"}], [12, lunge],
			[14, {"t": 10.0, "head": -10.0, "ua_f": 100.0, "fa_f": 95.0, "sa_f": 95.0, "th_f": 50.0, "sh_f": -10.0, "face": "angry"}], [10, "idle"]],
		"hits": [{"f": [11, 22], "seg": "pts", "pts": [[-20, -140], [120, -140]], "r": 50.0, "dmg": 120.0, "stun": 24, "bstun": 18, "kb": 5.0, "lift": -9.0, "kd": true, "hs": 14, "spark": "slash", "sfx": "slash_h", "chip": 0.12}],
		"vel": [[11, 24.0], [22, 3.0]], "slide": true, "pass": true, "ghost": true, "sfx": [[10, "dash"], [11, "swing_h"]], "trail": "sword_f",
	}
	moves.s3 = {
		"title": "Kokuto: RISING YORU!",
		"anim": [[4, {"base": "crouch", "ua_f": 20.0, "fa_f": 30.0, "sa_f": 10.0}], [5, {"t": -16.0, "head": -24.0, "ua_f": 165.0, "fa_f": 175.0, "sa_f": 180.0, "th_f": 10.0, "sh_f": 0.0, "th_b": -10.0, "sh_b": -6.0, "face": "shout"}],
			[12, {"t": -16.0, "head": -24.0, "ua_f": 168.0, "fa_f": 177.0, "sa_f": 182.0, "th_f": 10.0, "sh_f": 0.0, "th_b": -10.0, "sh_b": -6.0, "face": "shout"}], [14, "idle"]],
		"hits": [{"f": [5, 15], "seg": "sword_f", "r": 34.0, "dmg": 105.0, "stun": 22, "bstun": 14, "kb": 3.0, "lift": -16.0, "kd": true, "hs": 12, "spark": "slash", "sfx": "slash_h"}],
		"vel": [[5, 3.0, -14.0]], "invuln": [1, 9], "sfx": [[4, "swing_h"]], "trail": "sword_f",
	}
	var aura := raise.duplicate()
	aura.fx = "aura_dark"
	moves["super"] = {
		"title": "Kokuto: SAIKYO NO ZANGEKI!",
		"super": true,
		"anim": [[26, aura], [5, cut], [20, cut], [16, "idle"]],
		"proj": [[30, {"type": "black_slash", "pos": [140, -170], "vel": [9, 0], "r": 90.0, "size": 1.9, "life": 110, "hp": 9, "hits": 5, "every": 5,
			"hit": {"dmg": 52.0, "stun": 26, "bstun": 12, "kb": 4.0, "lift": -5.0, "kd": true, "hs": 8, "spark": "slash", "sfx": "slash_h", "chip": 0.2}}]],
		"invuln": [1, 28], "fx": [[30, "slash_dark", [150, -170]]], "sfx": [[2, "aura"], [28, "swing_h"], [29, "wind"]], "shake_at": [[30, 10.0]], "zoom": true, "trail": "sword_f",
	}


func more_moves() -> void:
	var raise := {"t": -14.0, "head": 6.0, "ua_f": 160.0, "fa_f": 200.0, "sa_f": 240.0, "ua_b": 150.0, "fa_b": 190.0, "face": "angry"}
	var cut := {"t": 26.0, "head": -14.0, "ua_f": 95.0, "fa_f": 70.0, "sa_f": 40.0, "ua_b": 85.0, "fa_b": 60.0, "th_f": 50.0, "sh_f": -6.0, "face": "shout"}
	moves.s2_h = {
		"title": "KOGATANA!",
		"anim": [[8, {"t": 6.0, "ua_b": 100.0, "fa_b": 140.0, "ua_f": 20.0, "fa_f": 60.0, "sa_f": 40.0, "face": "closed"}], [4, {"t": 14.0, "ua_b": 95.0, "fa_b": 90.0, "face": "attack", "hand_b": "open"}], [12, "idle"]],
		"proj": [[10, {"type": "knife", "pos": [60, -170], "vel": [22, 0], "r": 16.0, "life": 50,
			"hit": {"dmg": 35.0, "stun": 16, "bstun": 8, "kb": 3.0, "hs": 5, "spark": "punch", "sfx": "hit_l"}}]],
		"sfx": [[9, "swing_l"]],
	}
	moves.s3_h = {
		"title": "SENKI: COUNTER STANCE!",
		"anim": [[30, {"t": -6.0, "head": 6.0, "ua_f": 60.0, "fa_f": 150.0, "sa_f": 200.0, "ua_b": 70.0, "fa_b": 150.0, "face": "closed"}], [10, "idle"]],
		"counter": [2, 28, "counter_slash"], "sfx": [[1, "swing_l"]],
	}
	moves.counter_slash = {
		"title": "SENKI!",
		"anim": [[2, raise], [3, cut], [10, cut], [12, "idle"]],
		"hits": [{"f": [3, 9], "seg": "pts", "pts": [[0, -150], [200, -150]], "r": 70.0, "dmg": 150.0, "stun": 30, "bstun": 18, "kb": 9.0, "lift": -12.0, "kd": true, "hs": 18, "spark": "slash", "sfx": "slash_h"}],
		"invuln": [1, 8], "fx": [[4, "slash_dark", [140, -150]]], "trail": "sword_f",
	}
	moves.s4 = {
		"title": "Yoru: ICHIMONJI!",
		"anim": [[14, {"t": -20.0, "ua_f": -40.0, "fa_f": -20.0, "sa_f": -100.0, "ua_b": 40.0, "fa_b": 100.0, "th_f": 40.0, "face": "angry"}],
			[4, {"t": 24.0, "head": -10.0, "ua_f": 95.0, "fa_f": 95.0, "sa_f": 95.0, "ua_b": -20.0, "fa_b": 20.0, "th_f": 60.0, "sh_f": -10.0, "face": "shout"}],
			[12, {"t": 24.0, "head": -10.0, "ua_f": 95.0, "fa_f": 95.0, "sa_f": 95.0, "ua_b": -20.0, "fa_b": 20.0, "th_f": 60.0, "sh_f": -10.0, "face": "shout"}], [14, "idle"]],
		"hits": [{"f": [15, 22], "seg": "sword_f", "r": 40.0, "dmg": 140.0, "stun": 26, "bstun": 18, "kb": 12.0, "lift": -6.0, "kd": true, "hs": 15, "spark": "slash", "sfx": "slash_h", "chip": 0.12}],
		"fx": [[16, "slash_dark", [220, -140]]], "sfx": [[13, "swing_h"]], "trail": "sword_f", "shake_at": [[16, 6.0]],
	}
	var dash := {"t": 34.0, "head": -20.0, "ua_f": 95.0, "fa_f": 92.0, "sa_f": 92.0, "ua_b": -40.0, "fa_b": -20.0, "th_f": 80.0, "sh_f": 0.0, "th_b": -60.0, "sh_b": -70.0, "face": "attack"}
	var up := dash.duplicate()
	up.ua_f = 160.0
	up.fa_f = 175.0
	up.sa_f = 190.0
	moves.super2 = {
		"title": "Yoru: TSUBAME GAESHI!",
		"super": true,
		"anim": [[20, {"base": "guard", "fx": "aura_dark"}], [5, dash], [5, up], [5, dash], [5, up], [5, dash], [6, raise], [4, cut], [16, cut], [14, "idle"]],
		"hits": multi(21, 5, 5, {"seg": "pts", "pts": [[-40, -150], [160, -150]], "r": 80.0, "dmg": 24.0, "stun": 28, "bstun": 10, "kb": 1.0, "hs": 4, "spark": "slash", "sfx": "slash_l", "chip": 0.15})
			+ [{"f": [52, 58], "seg": "pts", "pts": [[0, -150], [220, -150]], "r": 90.0, "dmg": 160.0, "stun": 30, "bstun": 18, "kb": 14.0, "lift": -13.0, "kd": true, "hs": 22, "spark": "slash", "sfx": "slash_h", "chip": 0.2}],
		"vel": [[21, 9.0], [45, 1.0]], "slide": true, "invuln": [1, 22], "ghost": true, "zoom": true, "trail": "sword_f",
		"sfx": [[2, "aura"], [21, "dash"], [22, "swing_h"], [32, "swing_h"], [42, "swing_h"], [51, "slash_h"]], "fx": [[53, "slash_dark", [140, -150]]], "shake_at": [[53, 12.0]],
	}


# ---------------------------------------------------------------- drawing

func draw_sword(cv: CanvasItem, J: Dictionary, _p: Dictionary, s: String, st: Dictionary) -> void:
	if s != "f":
		return
	var hand: Vector2 = J.hand_f
	var tip: Vector2 = J.tip_f
	var v := (tip - hand).normalized()
	var n := Vector2(-v.y, v.x)
	var start := hand - v * 30.0
	# long grip with gold wrap and the cross shaped hilt of Yoru
	shape(cv, capsule(start, hand + v * 12.0, 4.5, 4.5, 3), Color("2c1d14"), st, false, 1.8)
	for i in 4:
		var c := start + v * (6.0 + i * 9.0)
		cv.draw_line(c - n * 4.5, c + n * 4.5, fc(Color("c9a03a"), st), 1.6, true)
	var g := hand + v * 14.0
	shape(cv, capsule(g - n * 30.0, g + n * 30.0, 4.0, 4.0, 3), Color("d4aa3c"), st, false, 1.8)
	for e in [g - n * 30.0, g + n * 30.0]:
		cv.draw_circle(e, 5.5, fc(Color("d4aa3c"), st))
		cv.draw_circle(e, 2.5, fc(Color("2f8a5a"), st))
	cv.draw_circle(g, 6.0, fc(Color("2f8a5a"), st))
	# the wide black blade
	var b0 := g + v * 4.0
	var pts := PackedVector2Array()
	var steps := 8
	for i in steps + 1:
		var u := float(i) / steps
		var w := lerpf(7.5, 1.0, pow(u, 2.5))
		pts.append(b0.lerp(tip, u) + n * (sin(u * PI * 0.9) * 5.0 + w))
	for i in range(steps, -1, -1):
		var u := float(i) / steps
		var w := lerpf(7.5, 1.0, pow(u, 2.5))
		pts.append(b0.lerp(tip, u) + n * (sin(u * PI * 0.9) * 5.0 - w))
	if not Geometry2D.triangulate_polygon(pts).is_empty():
		cv.draw_colored_polygon(pts, fc(Color("17181d"), st))
	outline(cv, pts, 1.6)
	var edge := PackedVector2Array()
	for i in steps + 1:
		var u := float(i) / steps
		edge.append(b0.lerp(tip, u) + n * (sin(u * PI * 0.9) * 5.0 - lerpf(5.5, 0.5, pow(u, 2.5))))
	cv.draw_polyline(edge, Color(0.55, 1.0, 0.7, 0.85), 1.6, true)


func draw_torso_extra(cv: CanvasItem, _J: Dictionary, _p: Dictionary, st: Dictionary, L: float, ch: float) -> void:
	coat_torso(cv, st, L, ch, col.top, Color("6a1f2a"))
	# the little cross pendant (a knife, Kogatana)
	var c := Vector2(8 * ch, -L * 0.55)
	cv.draw_line(Vector2(4 * ch, -L * 0.92), c, fc(Color("c9a03a"), st), 1.4, true)
	cv.draw_line(c + Vector2(0, -6), c + Vector2(0, 12), fc(Color("e0c050"), st), 3.0, true)
	cv.draw_line(c + Vector2(-5, -1), c + Vector2(5, -1), fc(Color("e0c050"), st), 3.0, true)
	# belt
	shape(cv, PackedVector2Array([Vector2(-16 * ch, 9), Vector2(17 * ch, 9), Vector2(16 * ch, -1), Vector2(-16 * ch, 0)]), Color("3a2a1e"), st, false, 1.6)
	shape(cv, PackedVector2Array([Vector2(6 * ch, 10), Vector2(14 * ch, 10), Vector2(14 * ch, -2), Vector2(6 * ch, -2)]), Color("d4aa3c"), st, false, 1.4)


func draw_back_fx(cv: CanvasItem, J: Dictionary, p: Dictionary, st: Dictionary) -> void:
	if p.get("fx", "") == "aura_dark":
		var tt: float = st.get("time", 0.0)
		for i in 3:
			cv.draw_circle(J.neck + Vector2(0, 30), 110.0 + i * 26.0 + 8.0 * sin(tt * 8.0 + i), Color(0.1, 0.35, 0.2, 0.12))
	coat_tail(cv, J, st, col.top, false, 112.0, 20.0)


func draw_leg_extra(cv: CanvasItem, J: Dictionary, _p: Dictionary, s: String, st: Dictionary) -> void:
	if s == "f":
		coat_tail(cv, J, st, col.top, true, 104.0, 18.0)


func draw_hair(cv: CanvasItem, R: float, _p: Dictionary, st: Dictionary) -> void:
	spikes(cv, R * 0.98, 160.0, 330.0, 7, R * 0.16, col.hair, st, 0.3, Vector2(0, -R * 0.08), 13, -24.0)
	cv.draw_line(Vector2(-R * 0.28, -R * 0.1), Vector2(-R * 0.2, R * 0.5), fc(col.hair, st), 4.0, true)


func draw_face_extra(cv: CanvasItem, R: float, _p: Dictionary, st: Dictionary) -> void:
	var ink := fc(col.hair, st)
	# curled mustache and pointed beard
	var m := Vector2(R * 0.48, R * 0.52)
	cv.draw_polyline(PackedVector2Array([m + Vector2(-R * 0.3, R * 0.02), m + Vector2(-R * 0.12, -R * 0.06), m + Vector2(0, -R * 0.02), m + Vector2(R * 0.14, -R * 0.06), m + Vector2(R * 0.3, -R * 0.14)]), ink, 3.0, true)
	var chin := Vector2(R * 0.42, R * 1.14)
	shape(cv, PackedVector2Array([chin + Vector2(-R * 0.12, -R * 0.2), chin + Vector2(R * 0.1, -R * 0.2), chin + Vector2(R * 0.02, R * 0.26)]), col.hair, st, false, 1.4)


func draw_hat(cv: CanvasItem, R: float, _p: Dictionary, st: Dictionary) -> void:
	var hat := Color("1c1a20")
	# wide brim
	shape(cv, ellipse(Vector2(R * 0.05, -R * 0.62), R * 1.7, R * 0.3, 22, -0.1), hat, st)
	# tall crown
	var crown := PackedVector2Array([Vector2(-R * 0.85, -R * 0.68), Vector2(R * 0.85, -R * 0.78), Vector2(R * 0.75, -R * 1.5), Vector2(R * 0.2, -R * 1.72), Vector2(-R * 0.55, -R * 1.62), Vector2(-R * 0.82, -R * 1.3)])
	shape(cv, crown, hat, st)
	shape(cv, PackedVector2Array([Vector2(-R * 0.85, -R * 0.68), Vector2(R * 0.85, -R * 0.78), Vector2(R * 0.83, -R * 0.94), Vector2(-R * 0.84, -R * 0.86)]), Color("6a1f2a"), st, false, 1.6)
	# big feather plume sweeping back
	flutter(cv, Vector2(-R * 0.55, -R * 1.25), -150.0, R * 1.7, R * 0.42, R * 0.18, Color("e8efe6"), st, 0.0, 5)
	flutter(cv, Vector2(-R * 0.5, -R * 1.1), -130.0, R * 1.3, R * 0.3, R * 0.12, Color("8fc7a0"), st, 1.0, 4)


func update_fx(f, fx) -> void:
	if String(f.pose.get("fx", "")) == "aura_dark" and Engine.get_physics_frames() % 2 == 0:
		fx.smoke(f.world_point(f.J.hip) + Vector2(randf_range(-60, 60), randf_range(-160, 20)), Color(0.12, 0.3, 0.2, 0.5), 1.5)
