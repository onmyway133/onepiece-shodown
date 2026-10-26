extends CharData
## Nami: Cat Burglar with the Sorcery Clima-Tact. Fast, light and a weather
## zoner: thunder balls, gusts, mirages and lightning from storm clouds.


func setup() -> void:
	id = "nami"
	display_name = "NAMI"
	epithet = "Cat Burglar"
	quote = "The weather is on my side. Pay up!"
	accent = Color("f08a24")
	trail_color = Color(1.0, 0.95, 0.55)
	has_swords = true
	ai_zoner = true
	dims.thigh = 56.0
	dims.shin = 58.0
	dims.torso = 70.0
	dims.head = 23.0
	dims.ua = 38.0
	dims.fa = 36.0
	dims.chest = 0.98
	dims.limb = 0.82
	dims.foot = 20.0
	dims.sword = 74.0
	col.skin = Color("f6cfaa")
	col.hair = Color("f07a1e")
	col.top = Color("f6cfaa")
	col.pants = Color("3d63a6")
	col.shoes = Color("c8452e")
	col.eye = Color("8a4a1a")
	style = {"top": "none", "sleeves": "none", "pants": "long", "feet": "heel", "cuff": false, "slim": true}
	walk_speed = 4.9
	back_speed = 4.0
	jump_vy = -20.0
	dash_speed = 14.5
	max_hp = 900.0

	poses.idle = {"t": 2.0, "head": -4.0, "ua_f": 26.0, "fa_f": 128.0, "sa_f": 150.0, "ua_b": -8.0, "fa_b": 40.0, "th_f": 18.0, "sh_f": -2.0, "th_b": -12.0, "sh_b": -16.0, "hand_b": "open"}
	poses.idle_b = {"hy": 2.0, "t": 3.0, "head": -6.0, "ua_f": 28.0, "fa_f": 130.0, "sa_f": 152.0, "ua_b": -6.0, "fa_b": 42.0, "th_f": 19.0, "sh_f": -3.0, "th_b": -13.0, "sh_b": -16.0, "hand_b": "open"}
	poses.walk1 = {"t": 6.0, "ua_f": 26.0, "fa_f": 128.0, "sa_f": 150.0, "ua_b": -16.0, "fa_b": 10.0, "th_f": 30.0, "sh_f": 4.0, "th_b": -24.0, "sh_b": -28.0}
	poses.walk2 = {"t": 6.0, "ua_f": 24.0, "fa_f": 126.0, "sa_f": 150.0, "ua_b": 10.0, "fa_b": 30.0, "th_f": 10.0, "sh_f": -28.0, "th_b": -4.0, "sh_b": -10.0, "hy": -3.0}
	poses.guard = {"t": -6.0, "head": 8.0, "ua_f": 60.0, "fa_f": 150.0, "sa_f": 190.0, "ua_b": 60.0, "fa_b": 150.0, "th_f": 20.0, "sh_f": 8.0, "th_b": -22.0, "sh_b": -22.0, "face": "angry"}
	poses.win = {"t": -4.0, "head": -14.0, "ua_f": 165.0, "fa_f": 175.0, "sa_f": 180.0, "ua_b": -20.0, "fa_b": 50.0, "hand_b": "open", "th_f": 14.0, "sh_f": -30.0, "th_b": -8.0, "sh_b": -4.0, "face": "grin"}
	poses.intro = {"t": 0.0, "head": -6.0, "ua_f": 40.0, "fa_f": 150.0, "sa_f": 200.0, "ua_b": 20.0, "fa_b": 150.0, "hand_b": "open", "th_f": 6.0, "sh_f": 0.0, "th_b": -8.0, "sh_b": -2.0, "face": "grin"}
	poses.tempo = {"t": -6.0, "head": -12.0, "ua_f": 150.0, "fa_f": 165.0, "sa_f": 170.0, "ua_b": 40.0, "fa_b": 120.0, "hand_b": "open", "face": "shout", "fx": "charge"}

	var point := {"t": 12.0, "head": -8.0, "ua_f": 88.0, "fa_f": 90.0, "sa_f": 90.0, "ua_b": -30.0, "fa_b": 10.0, "th_f": 36.0, "sh_f": -4.0, "th_b": -22.0, "sh_b": -26.0, "face": "shout", "fx": "charge"}
	var swing_up := {"t": -12.0, "head": 6.0, "ua_f": 160.0, "fa_f": 190.0, "sa_f": 220.0, "ua_b": 30.0, "fa_b": 100.0, "face": "angry"}
	var swing_down := {"t": 22.0, "head": -12.0, "ua_f": 95.0, "fa_f": 70.0, "sa_f": 45.0, "ua_b": -20.0, "fa_b": 20.0, "th_f": 42.0, "sh_f": -6.0, "face": "shout"}

	moves.light = {
		"anim": [[3, {"ua_f": 50.0, "fa_f": 110.0, "sa_f": 120.0, "face": "attack"}], [3, {"t": 12.0, "ua_f": 90.0, "fa_f": 88.0, "sa_f": 90.0, "face": "attack"}], [4, {"t": 12.0, "ua_f": 90.0, "fa_f": 88.0, "sa_f": 90.0}], [8, "idle"]],
		"hits": [{"f": [5, 9], "seg": "sword_f", "r": 16.0, "dmg": 38.0, "stun": 13, "bstun": 9, "kb": 4.0, "hs": 5, "sfx": "hit_l"}],
		"sfx": [[2, "swing_l"]], "trail": "sword_f", "cancel": true, "chain": ["heavy", "kick"],
	}
	moves.heavy = {
		"anim": [[8, swing_up], [3, swing_down], [5, swing_down], [13, "idle"]],
		"hits": [{"f": [9, 14], "seg": "sword_f", "r": 22.0, "dmg": 92.0, "stun": 21, "bstun": 15, "kb": 6.5, "hs": 11, "spark": "electric", "sfx": "hit_h", "chip": 0.08}],
		"sfx": [[7, "swing_h"]], "trail": "sword_f", "cancel": true,
	}
	moves.kick = {
		"anim": [[4, {"t": -10.0, "th_f": 70.0, "sh_f": 20.0}], [3, {"t": -30.0, "head": 14.0, "th_f": 130.0, "sh_f": 140.0, "face": "attack"}], [5, {"t": -30.0, "head": 14.0, "th_f": 130.0, "sh_f": 140.0}], [10, "idle"]],
		"hits": [{"f": [7, 12], "seg": "foot_f", "r": 18.0, "dmg": 54.0, "stun": 16, "bstun": 11, "kb": 5.5, "hs": 7}],
		"sfx": [[3, "swing_m"]], "trail": "foot_f", "cancel": true,
	}
	moves.c_light = {
		"anim": [[3, {"base": "crouch", "ua_f": 70.0, "fa_f": 90.0, "sa_f": 110.0}], [3, {"base": "crouch", "t": 30.0, "ua_f": 92.0, "fa_f": 92.0, "sa_f": 96.0, "face": "attack"}], [4, {"base": "crouch", "t": 30.0, "ua_f": 92.0, "fa_f": 92.0, "sa_f": 96.0}], [7, "crouch"]],
		"hits": [{"f": [5, 9], "seg": "sword_f", "r": 16.0, "dmg": 34.0, "stun": 12, "bstun": 8, "kb": 3.5, "lvl": "low", "hs": 5, "sfx": "hit_l"}],
		"sfx": [[2, "swing_l"]], "trail": "sword_f", "crouch": true, "cancel": true, "chain": ["c_heavy", "c_kick"],
	}
	moves.c_heavy = {
		"anim": [[6, {"base": "crouch", "ua_f": 30.0, "fa_f": 50.0, "sa_f": 30.0}], [4, {"t": -10.0, "head": -20.0, "ua_f": 150.0, "fa_f": 168.0, "sa_f": 175.0, "th_f": 20.0, "sh_f": 0.0, "th_b": -14.0, "sh_b": -10.0, "face": "shout", "fx": "charge"}],
			[8, {"t": -10.0, "head": -20.0, "ua_f": 152.0, "fa_f": 170.0, "sa_f": 178.0, "th_f": 20.0, "sh_f": 0.0, "th_b": -14.0, "sh_b": -10.0, "face": "shout"}], [13, "crouch"]],
		"hits": [{"f": [8, 15], "seg": "sword_f", "r": 26.0, "dmg": 80.0, "stun": 20, "bstun": 13, "kb": 3.0, "lift": -15.0, "kd": true, "hs": 10, "spark": "electric", "sfx": "hit_h"}],
		"sfx": [[5, "swing_h"]], "trail": "sword_f", "crouch": true, "cancel": true,
	}
	moves.c_kick = {
		"anim": [[4, {"base": "crouch", "t": 34.0}], [3, {"base": "crouch", "t": 36.0, "th_f": 92.0, "sh_f": 92.0, "face": "attack"}], [5, {"base": "crouch", "t": 36.0, "th_f": 92.0, "sh_f": 92.0}], [11, "crouch"]],
		"hits": [{"f": [6, 11], "seg": "foot_f", "r": 17.0, "dmg": 52.0, "stun": 17, "bstun": 11, "kb": 4.0, "lvl": "low", "kd": true, "lift": -6.0, "hs": 7}],
		"sfx": [[3, "swing_m"]], "trail": "foot_f", "crouch": true,
	}
	moves.j_light = {
		"anim": [[3, {"base": "jump", "ua_f": 70.0, "fa_f": 100.0, "sa_f": 110.0}], [3, {"base": "jump", "ua_f": 95.0, "fa_f": 100.0, "sa_f": 120.0, "face": "attack"}], [10, {"base": "jump", "ua_f": 95.0, "fa_f": 100.0, "sa_f": 120.0}], [6, "jump"]],
		"hits": [{"f": [5, 14], "seg": "sword_f", "r": 16.0, "dmg": 38.0, "stun": 14, "bstun": 9, "kb": 4.0, "lvl": "high", "hs": 6, "sfx": "hit_l"}],
		"sfx": [[2, "swing_l"]], "trail": "sword_f", "air": true,
	}
	moves.j_heavy = {
		"anim": [[5, {"base": "jump", "ua_f": 170.0, "fa_f": 190.0, "sa_f": 210.0, "face": "angry"}], [3, {"base": "jump", "t": 30.0, "ua_f": 80.0, "fa_f": 50.0, "sa_f": 20.0, "face": "shout"}], [10, {"base": "jump", "t": 30.0, "ua_f": 80.0, "fa_f": 50.0, "sa_f": 20.0}], [6, "jump"]],
		"hits": [{"f": [6, 16], "seg": "sword_f", "r": 22.0, "dmg": 80.0, "stun": 19, "bstun": 13, "kb": 6.0, "lvl": "high", "hs": 9, "spark": "electric", "sfx": "hit_h"}],
		"sfx": [[4, "swing_h"]], "trail": "sword_f", "air": true,
	}
	moves.j_kick = {
		"anim": [[3, {"base": "jump", "th_f": 60.0, "sh_f": 20.0}], [3, {"base": "jump", "t": -10.0, "th_f": 80.0, "sh_f": 76.0, "face": "attack"}], [12, {"base": "jump", "t": -10.0, "th_f": 80.0, "sh_f": 76.0}], [5, "jump"]],
		"hits": [{"f": [5, 17], "seg": "foot_f", "r": 18.0, "dmg": 50.0, "stun": 15, "bstun": 10, "kb": 5.0, "lvl": "high", "hs": 7}],
		"sfx": [[2, "swing_m"]], "trail": "foot_f", "air": true,
	}

	# --- specials
	moves.s1 = {
		"title": "THUNDER BALL!",
		"anim": [[10, {"base": "idle", "ua_f": 60.0, "fa_f": 120.0, "sa_f": 150.0, "face": "closed", "fx": "charge"}], [4, point], [12, point], [10, "idle"]],
		"proj": [[13, {"type": "thunder_ball", "pos": [110, -150], "vel": [6.5, 0], "r": 34.0, "life": 110,
			"hit": {"dmg": 90.0, "stun": 24, "bstun": 15, "kb": 6.0, "hs": 10, "spark": "electric", "sfx": "thunder", "chip": 0.12}}]],
		"sfx": [[4, "aura"], [12, "clash"]],
	}
	moves.s1_h = {
		"title": "THUNDER LANCE TEMPO!",
		"anim": [[14, {"base": "idle", "t": -10.0, "ua_f": 120.0, "fa_f": 140.0, "sa_f": 160.0, "face": "angry", "fx": "charge"}], [4, point], [12, point], [12, "idle"]],
		"proj": [[16, {"type": "lance", "pos": [110, -150], "vel": [19, 0], "r": 26.0, "life": 60,
			"hit": {"dmg": 100.0, "stun": 24, "bstun": 15, "kb": 9.0, "kd": true, "lift": -7.0, "hs": 11, "spark": "electric", "sfx": "thunder", "chip": 0.12}}]],
		"sfx": [[6, "aura"], [15, "thunder"]],
	}
	moves.s2 = {
		"title": "CYCLONE TEMPO!",
		"anim": [[10, {"t": -4.0, "ua_f": 30.0, "fa_f": 60.0, "sa_f": 80.0, "ua_b": 40.0, "fa_b": 100.0, "face": "closed"}], [4, {"t": 16.0, "head": -10.0, "ua_f": 100.0, "fa_f": 110.0, "sa_f": 20.0, "ua_b": -20.0, "fa_b": 20.0, "face": "shout"}],
			[12, {"t": 16.0, "head": -10.0, "ua_f": 100.0, "fa_f": 110.0, "sa_f": 20.0, "ua_b": -20.0, "fa_b": 20.0, "face": "shout"}], [10, "idle"]],
		"proj": [[13, {"type": "gust", "pos": [100, -130], "vel": [12, 0], "r": 50.0, "life": 55, "hits": 1,
			"hit": {"dmg": 60.0, "stun": 26, "bstun": 14, "kb": 16.0, "lift": -10.0, "kd": true, "hs": 8, "sfx": "hit_m", "chip": 0.05}}]],
		"fx": [[13, "tornado", [100, -130]]], "sfx": [[12, "wind"]],
	}
	moves.s3 = {
		"title": "THUNDERBOLT TEMPO!",
		"anim": [[10, "tempo"], [24, {"base": "tempo", "face": "grin"}], [12, "idle"]],
		"hits": multi(16, 3, 4, {"seg": "pts", "pts": [[260, -320], [260, -10]], "r": 50.0, "dmg": 36.0, "stun": 24, "bstun": 12, "kb": 1.0, "lift": -10.0, "kd": true, "hs": 6, "spark": "electric", "sfx": "hit_m", "chip": 0.15},
			{"dmg": 48.0, "lift": -14.0, "hs": 12, "sfx": "hit_h"}),
		"invuln": [1, 8], "fx": [[4, "smoke_puff", [260, -330]], [16, "lightning", [260, -150]]], "sfx": [[3, "aura"], [15, "thunder"]], "shake_at": [[16, 7.0]],
	}
	var lift := {"t": 0.0, "head": -10.0, "ua_f": 175.0, "fa_f": 178.0, "sa_f": 180.0, "ua_b": 170.0, "fa_b": 176.0, "hand_b": "open", "th_f": 10.0, "sh_f": 0.0, "th_b": -10.0, "sh_b": -6.0, "face": "shout", "fx": "cloud"}
	moves["super"] = {
		"title": "ZEUS BREEZE TEMPO!",
		"super": true,
		"anim": [[24, {"base": "tempo", "fx": "cloud"}], [8, lift], [26, lift], [14, "idle"]],
		"hits": multi(32, 6, 4, {"seg": "pts", "pts": [[150, -320], [420, -320], [420, -10], [150, -10]], "r": 60.0, "dmg": 34.0, "stun": 30, "bstun": 10, "kb": 1.5, "lift": -6.0, "hs": 5, "spark": "electric", "sfx": "hit_m", "chip": 0.2},
			{"dmg": 120.0, "kb": 10.0, "lift": -16.0, "kd": true, "hs": 22, "sfx": "hit_h"}),
		"invuln": [1, 32], "zoom": true,
		"fx": [[6, "smoke_puff", [280, -330]], [32, "lightning", [200, -150]], [36, "lightning", [330, -150]], [40, "lightning", [260, -150]], [44, "lightning", [390, -150]], [52, "lightning", [280, -150]]],
		"sfx": [[2, "aura"], [31, "thunder"], [40, "thunder"], [52, "thunder"]], "shake_at": [[32, 8.0], [52, 14.0]],
	}


func more_moves() -> void:
	var back := {"t": -20.0, "head": 10.0, "ua_f": 50.0, "fa_f": 150.0, "sa_f": 180.0, "ua_b": -40.0, "fa_b": 0.0, "hand_b": "open", "th_f": 40.0, "sh_f": 20.0, "th_b": -10.0, "sh_b": -40.0, "face": "grin"}
	moves.s2_h = {
		"title": "MIRAGE TEMPO!",
		"anim": [[14, back], [4, {"base": "idle", "ua_f": 88.0, "fa_f": 90.0, "sa_f": 90.0, "face": "shout", "fx": "charge"}], [10, {"base": "idle", "ua_f": 88.0, "fa_f": 90.0, "sa_f": 90.0, "face": "shout"}], [10, "idle"]],
		"proj": [[16, {"type": "thunder_ball", "pos": [100, -150], "vel": [8.0, 0], "r": 26.0, "life": 80,
			"hit": {"dmg": 70.0, "stun": 22, "bstun": 13, "kb": 5.0, "hs": 9, "spark": "electric", "sfx": "thunder", "chip": 0.1}}]],
		"vel": [[1, -16.0], [12, 0.0]], "slide": true, "ghost": true, "invuln": [1, 14], "fx": [[1, "smoke_puff", [0, -140]]], "sfx": [[1, "dash"], [15, "clash"]],
	}
	var spin := {"t": -6.0, "head": -16.0, "ua_f": 175.0, "fa_f": 178.0, "sa_f": 180.0, "ua_b": 170.0, "fa_b": 176.0, "hand_b": "open", "th_f": 30.0, "sh_f": 20.0, "th_b": -20.0, "sh_b": -40.0, "face": "shout", "fx": "charge"}
	moves.s3_h = {
		"title": "TORNADO TEMPO!",
		"anim": [[4, {"base": "crouch", "fx": "charge"}], [5, spin], [16, spin], [12, "idle"]],
		"hits": multi(5, 4, 4, {"seg": "pts", "pts": [[0, -280], [0, -40]], "r": 62.0, "dmg": 28.0, "stun": 20, "bstun": 9, "kb": 2.0, "lift": -12.0, "kd": true, "hs": 5, "sfx": "hit_m"},
			{"dmg": 40.0, "lift": -15.0, "kb": 6.0, "hs": 10, "sfx": "hit_h"}),
		"vel": [[5, 2.0, -12.0]], "invuln": [1, 9], "fx": [[5, "tornado", [0, -120]], [12, "tornado", [0, -200]]], "sfx": [[4, "wind"]],
	}
	moves.s4 = {
		"title": "BLACK BALL!",
		"anim": [[12, {"base": "tempo", "fx": "cloud"}], [4, point_up()], [12, point_up()], [10, "idle"]],
		"proj": [[14, {"type": "cloud", "pos": [80, -215], "vel": [2.6, 0], "r": 72.0, "life": 200, "hp": 3, "hits": 3, "every": 22,
			"hit": {"dmg": 45.0, "stun": 22, "bstun": 10, "kb": 2.0, "lift": -6.0, "hs": 7, "spark": "electric", "sfx": "thunder", "chip": 0.15}}]],
		"sfx": [[4, "aura"], [14, "wind"]],
	}
	var wide := {"t": -10.0, "head": -18.0, "ua_f": 165.0, "fa_f": 172.0, "sa_f": 178.0, "ua_b": 120.0, "fa_b": 150.0, "hand_b": "open", "th_f": 24.0, "sh_f": 0.0, "th_b": -24.0, "sh_b": -12.0, "face": "shout", "fx": "cloud"}
	var hits := []
	var fxs := [[4, "smoke_puff", [300, -330]]]
	var sfxs := [[2, "aura"]]
	var i := 0
	for x in [110, 190, 270, 350, 430, 300]:
		var f := 30 + i * 5
		var h := {"f": [f, f + 2], "seg": "pts", "pts": [[x, -320], [x, -10]], "r": 58.0, "dmg": 32.0, "stun": 30, "bstun": 9, "kb": 1.0, "lift": -6.0, "hs": 5, "spark": "electric", "sfx": "hit_m", "chip": 0.2}
		if i == 5:
			h.merge({"pts": [[160, -320], [440, -10]], "r": 90.0, "dmg": 140.0, "kb": 12.0, "lift": -17.0, "kd": true, "hs": 24, "sfx": "hit_h"}, true)
		hits.append(h)
		fxs.append([f, "lightning", [x, -150]])
		sfxs.append([f - 1, "thunder"])
		i += 1
	moves.super2 = {
		"title": "RAITEI!",
		"super": true,
		"anim": [[22, {"base": "tempo", "fx": "cloud"}], [6, wide], [32, wide], [14, "idle"]],
		"hits": hits, "fx": fxs, "sfx": sfxs, "invuln": [1, 30], "zoom": true, "shake_at": [[30, 6.0], [40, 6.0], [55, 16.0]],
	}


func point_up() -> Dictionary:
	return {"t": -8.0, "head": -16.0, "ua_f": 140.0, "fa_f": 150.0, "sa_f": 150.0, "ua_b": -20.0, "fa_b": 20.0, "hand_b": "open", "face": "shout"}


# ---------------------------------------------------------------- drawing

func torso_pts(L: float, ch: float) -> PackedVector2Array:
	# slim waist and wider hips
	return PackedVector2Array([
		Vector2(-17 * ch, 8), Vector2(17 * ch, 8),
		Vector2(14 * ch, -L * 0.2), Vector2(12 * ch, -L * 0.42),
		Vector2(17 * ch, -L * 0.62), Vector2(19 * ch, -L * 0.76), Vector2(16 * ch, -L * 0.92), Vector2(11 * ch, -L - 2.0),
		Vector2(-10 * ch, -L - 1), Vector2(-16 * ch, -L * 0.88), Vector2(-17 * ch, -L * 0.66), Vector2(-13 * ch, -L * 0.42),
		Vector2(-15 * ch, -L * 0.14),
	])


func draw_anatomy(cv: CanvasItem, L: float, ch: float, st: Dictionary) -> void:
	var line := shadow_of(fc(col.skin, st)).darkened(0.15)
	cv.draw_polyline(PackedVector2Array([Vector2(4 * ch, -L * 0.93), Vector2(10 * ch, -L * 0.9), Vector2(15 * ch, -L * 0.93)]), Color(line, 0.6), 1.2, true)
	cv.draw_circle(Vector2(8 * ch, -L * 0.24), 1.6, Color(line, 0.8))
	cv.draw_polyline(PackedVector2Array([Vector2(12 * ch, -L * 0.48), Vector2(10 * ch, -L * 0.34), Vector2(11 * ch, -L * 0.2)]), Color(line, 0.5), 1.2, true)


func draw_torso_extra(cv: CanvasItem, _J: Dictionary, _p: Dictionary, st: Dictionary, L: float, ch: float) -> void:
	# low-rise jeans and a belt
	var jeans := PackedVector2Array([Vector2(-17.5 * ch, 9), Vector2(17.5 * ch, 9), Vector2(15 * ch, -L * 0.14), Vector2(-15.5 * ch, -L * 0.12)])
	shape(cv, jeans, col.pants, st, true, 2.0)
	cv.draw_line(Vector2(-15.5 * ch, -L * 0.1), Vector2(15 * ch, -L * 0.12), fc(Color("5a3a22"), st), 3.0, true)
	cv.draw_rect(Rect2(Vector2(8 * ch, -L * 0.15), Vector2(5, 5)), fc(Color("e0c050"), st))
	# bikini top: two cups with a light shine and strings
	var bk := Color("5fb0e8")
	for c in [Vector2(12 * ch, -L * 0.7), Vector2(-3 * ch, -L * 0.7)]:
		var cup := ellipse(c, 8.5 * ch, 7.0, 12)
		shape(cv, cup, bk, st, true, 1.8)
		cv.draw_arc(c + Vector2(-1, -1), 4.0, PI + 0.4, TAU - 0.6, 6, Color(1, 1, 1, 0.5), 1.4, true)
	var string := fc(Color("2f6fa8"), st)
	cv.draw_line(Vector2(3.5 * ch, -L * 0.72), Vector2(5.5 * ch, -L * 0.72), string, 2.0, true)
	cv.draw_line(Vector2(15 * ch, -L * 0.76), Vector2(13 * ch, -L * 0.98), string, 1.6, true)
	cv.draw_line(Vector2(-8 * ch, -L * 0.72), Vector2(-15 * ch, -L * 0.7), string, 1.6, true)


func draw_arm_extra(cv: CanvasItem, J: Dictionary, _p: Dictionary, s: String, st: Dictionary) -> void:
	if s != "f":
		return
	# pinwheel and tangerine tattoo on the shoulder
	var sh: Vector2 = J.shoulder
	var el: Vector2 = J.elbow_f
	var c := sh.lerp(el, 0.32)
	var ink := fc(Color("2f6fa8"), st)
	for k in 4:
		var a := k * PI * 0.5 + 0.3
		cv.draw_colored_polygon(PackedVector2Array([c, c + Vector2(cos(a), sin(a)) * 6.0, c + Vector2(cos(a + 0.9), sin(a + 0.9)) * 3.5]), ink)
	cv.draw_circle(c + Vector2(4, 5), 2.4, fc(Color("f08a24"), st))
	# gold bangle
	var ha: Vector2 = J.hand_f
	var fa := el.lerp(ha, 0.78)
	var d := (ha - el).normalized()
	var n := Vector2(-d.y, d.x) * 7.5
	cv.draw_line(fa + n, fa - n, fc(Color("e8c040"), st), 3.4, true)


func draw_foot(cv: CanvasItem, kn: Vector2, ft: Vector2, toe: Vector2, st: Dictionary) -> void:
	if style.feet != "heel":
		super(cv, kn, ft, toe, st)
		return
	var u := (toe - ft).normalized()
	if u == Vector2.ZERO:
		u = Vector2.RIGHT
	var v := Vector2(-u.y, u.x)
	if v.dot(ft - kn) < 0.0:
		v = -v
	var k: float = dims.limb
	var F: float = ft.distance_to(toe) / k
	# stiletto pin under the heel, then the shoe
	shape(cv, local_pts(ft, u, v, k, [[-7, 2], [-3, 2], [-5, 12], [-6.5, 12]]), col.shoes.darkened(0.3), st, false, 1.4)
	shape(cv, local_pts(ft, u, v, k, [[-8, -5], [-9, 2], [-6, 4], [F * 0.5, 8], [F + 8, 9.5], [F + 10, 6], [F + 4, 1], [F * 0.5, -2.5], [4, -6], [-2, -7]]), col.shoes, st, true, 1.8)
	var strap := local_pts(ft, u, v, k, [[0, -6.5], [6, 3]])
	cv.draw_line(strap[0], strap[1], fc(col.skin, st), 2.0, true)


func draw_sword(cv: CanvasItem, J: Dictionary, _p: Dictionary, s: String, st: Dictionary) -> void:
	if s != "f":
		return
	# Sorcery Clima-Tact: a blue segmented staff held near the middle
	var hand: Vector2 = J.hand_f
	var tip: Vector2 = J.tip_f
	var v := (tip - hand).normalized()
	var butt := hand - v * 52.0
	shape(cv, capsule(butt, tip, 4.2, 4.2, 4), Color("3d7fd0"), st, true, 1.8)
	for k in [0.18, 0.5, 0.82]:
		var c := butt.lerp(tip, k)
		shape(cv, capsule(c - v * 3.0, c + v * 3.0, 5.6, 5.6, 3), Color("e8eef6"), st, false, 1.4)
	for e in [butt, tip]:
		shape(cv, ellipse(e, 6.5, 6.5, 10), Color("1f4f9a"), st, true, 1.6)


func draw_back_fx(cv: CanvasItem, J: Dictionary, _p: Dictionary, st: Dictionary) -> void:
	# long wavy orange hair hangs behind the body, so it is drawn first
	var R: float = dims.head
	xf(cv, J.head, J.head_ang)
	flutter(cv, Vector2(-R * 0.55, -R * 0.2), -22.0, R * 3.9, R * 0.62, R * 0.2, col.hair, st, 0.0, 6)
	flutter(cv, Vector2(-R * 0.2, -R * 0.4), -6.0, R * 3.4, R * 0.55, R * 0.15, col.hair.darkened(0.08), st, 1.4, 6)
	xf_reset(cv)


func draw_hair(cv: CanvasItem, R: float, _p: Dictionary, st: Dictionary) -> void:
	# rounded cap with a parted, side-swept fringe that leaves the eyes clear
	var cap := PackedVector2Array()
	for i in 15:
		var a := deg_to_rad(lerpf(130.0, 340.0, float(i) / 14.0))
		var r := R * 1.1 + sin(i * 2.3) * R * 0.04
		cap.append(Vector2(cos(a) * r, sin(a) * r))
	cap.append_array(local_pts(Vector2.ZERO, Vector2.RIGHT, Vector2.DOWN, R, [[0.86, -0.5], [0.62, -0.6], [0.3, -0.62], [-0.1, -0.54], [-0.36, -0.3], [-0.5, 0.1], [-0.62, 0.6], [-0.86, 0.4]]))
	shape(cv, cap, col.hair, st, true, 2.0)
	for lock in [[[-0.1, -0.9], [0.32, -0.84], [0.2, -0.44]], [[0.2, -0.95], [0.7, -0.8], [0.62, -0.46]], [[0.56, -0.9], [1.02, -0.6], [0.98, -0.3]]]:
		shape(cv, local_pts(Vector2.ZERO, Vector2.RIGHT, Vector2.DOWN, R, lock), col.hair, st, true, 1.8)
	# lock framing the face
	flutter(cv, Vector2(R * 0.96, -R * 0.4), 6.0, R * 1.5, R * 0.17, R * 0.06, col.hair, st, 2.1, 4)


func draw_face_extra(cv: CanvasItem, R: float, p: Dictionary, _st: Dictionary) -> void:
	var face: String = p.get("face", "normal")
	if face in ["hurt", "ko", "closed"]:
		return
	# a longer lash at the outer corner of the near eye and a hint of lip color
	var o: Vector2 = EYE_NEAR * R + Vector2(-R * 0.3, -R * 0.2)
	cv.draw_line(o, o + Vector2(-R * 0.1, -R * 0.08), OUTLINE, 2.0, true)
	if face in ["normal", "angry", "closed"]:
		var m := MOUTH * R
		cv.draw_line(m + Vector2(-R * 0.12, R * 0.06), m + Vector2(R * 0.1, R * 0.05), Color(0.85, 0.35, 0.35, 0.6), 2.0, true)


func draw_front_fx(cv: CanvasItem, J: Dictionary, p: Dictionary, st: Dictionary) -> void:
	var fxk: String = p.get("fx", "")
	var tt: float = st.get("time", 0.0)
	if fxk == "charge":
		var c: Vector2 = J.tip_f
		cv.draw_circle(c, 14.0 + 3.0 * sin(tt * 20.0), Color(0.5, 0.75, 1.0, 0.35))
		cv.draw_circle(c, 7.0, Color(0.9, 0.95, 1.0, 0.8))
		var rng := RandomNumberGenerator.new()
		rng.seed = int(tt * 30.0)
		for i in 4:
			var pts := PackedVector2Array([c])
			var ang := rng.randf() * TAU
			for k in 3:
				ang += rng.randf_range(-0.8, 0.8)
				pts.append(pts[pts.size() - 1] + Vector2(cos(ang), sin(ang)) * 11.0)
			cv.draw_polyline(pts, Color(1.0, 0.95, 0.5, 0.9), 2.0, true)
	elif fxk == "cloud":
		# a little thundercloud above the Clima-Tact
		var c: Vector2 = J.head + Vector2(10, -95)
		for k in 5:
			var off := Vector2((k - 2) * 20.0, sin(k * 1.7 + tt * 2.0) * 6.0)
			cv.draw_circle(c + off, 22.0 + 4.0 * sin(k + tt * 3.0), Color(0.2, 0.2, 0.28, 0.85))
		if int(tt * 10.0) % 4 == 0:
			var pts := PackedVector2Array([c + Vector2(0, 14)])
			for k in 4:
				pts.append(pts[pts.size() - 1] + Vector2((k % 2) * 16.0 - 8.0, 18.0))
			cv.draw_polyline(pts, Color(1.0, 0.95, 0.5), 3.0, true)
