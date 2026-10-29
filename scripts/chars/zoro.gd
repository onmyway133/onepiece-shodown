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
	dims.head = 23.5
	dims.ua = 43.0
	dims.fa = 41.0
	dims.chest = 1.36
	dims.limb = 1.1
	dims.sword = 124.0
	col.skin = Color("e2b083")
	col.hair = Color("4cb858")
	col.top = Color("18422b")
	col.sleeve = Color("18422b")
	col.pants = Color("17231c")
	col.shoes = Color("17171b")
	style = {"top": "coat", "sleeves": "long", "pants": "long", "feet": "boot", "cuff": false}
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

const GREEN_COAT := Color("18422b")
const GREEN_TRIM := Color("58b86c")
const CREAM_SASH := Color("ece5d5")
const GOLD := Color("e6b83c")
const CRIMSON := Color("981c26")


func draw_torso_extra(cv: CanvasItem, _J: Dictionary, _p: Dictionary, st: Dictionary, L: float, ch: float) -> void:
	# diagonal Mihawk scar across the bare chest
	var scar := Color("7e342d")
	cv.draw_line(Vector2(-3.5 * ch, -L * 0.88), Vector2(15.0 * ch, -L * 0.34), scar, 2.5, true)
	for i in 5:
		var u := (float(i) + 0.5) / 5.0
		var sp := Vector2(-3.5 * ch, -L * 0.88).lerp(Vector2(15.0 * ch, -L * 0.34), u)
		cv.draw_line(sp + Vector2(-3.0, 2.0), sp + Vector2(3.0, -2.0), scar, 1.4, true)
	# open dark-green Wano/post-timeskip coat over bare chest with bright green trim
	coat_torso(cv, st, L, ch, GREEN_COAT, GREEN_TRIM)
	# ribbed green haramaki waist wrap
	var h := PackedVector2Array([Vector2(-18 * ch, 9), Vector2(19 * ch, 9), Vector2(17 * ch, -L * 0.32), Vector2(-18 * ch, -L * 0.28)])
	shape(cv, h, Color("3c9648"), st)
	for i in 3:
		var y := -L * (0.06 + i * 0.09)
		cv.draw_line(Vector2(-16 * ch, y), Vector2(17 * ch, y - 1), fc(Color("286c32"), st), 1.4, true)
	for i in 6:
		var rx := lerpf(-14.0, 15.0, float(i) / 5.0) * ch
		cv.draw_line(Vector2(rx, 8.0), Vector2(rx * 0.94, -L * 0.28), fc(Color("286c32"), st), 1.2, true)
	# cream/white sash belt tied over the haramaki
	var belt := PackedVector2Array([Vector2(-18.5 * ch, 10.0), Vector2(19.5 * ch, 10.0), Vector2(18.5 * ch, 0.0), Vector2(-18.0 * ch, 1.0)])
	shape(cv, belt, CREAM_SASH, st, true, 2.2)
	cv.draw_line(Vector2(-16 * ch, 5.0), Vector2(17 * ch, 4.5), shadow_of(fc(CREAM_SASH, st)), 1.4, true)


func draw_arm_extra(cv: CanvasItem, J: Dictionary, _p: Dictionary, s: String, st: Dictionary) -> void:
	var el: Vector2 = J["elbow_" + s]
	var ha: Vector2 = J["hand_" + s]
	var k: float = dims.limb
	# dark cuff & green trim on coat sleeve wrists
	var w0 := el.lerp(ha, 0.72)
	var w1 := el.lerp(ha, 0.92)
	shape(cv, capsule(w0, w1, 9.8 * k, 8.8 * k), Color("11281b"), st, true, 2.0)
	var wd := (ha - el).normalized()
	var wn := Vector2(-wd.y, wd.x) * 9.5 * k
	cv.draw_line(w0 + wn, w0 - wn, fc(GREEN_TRIM, st), 2.2, true)
	if s != "b":
		return
	# black bandana tied around the left arm, with its ends trailing
	var a: Vector2 = J.shoulder.lerp(J.elbow_b, 0.42)
	var d: Vector2 = (J.elbow_b - J.shoulder).normalized()
	var n := Vector2(d.y, -d.x)
	var band := PackedVector2Array([a + n * 13.0 * k - d * 5.0, a + n * 13.5 * k + d * 5.0, a - n * 13.5 * k + d * 5.0, a - n * 13.0 * k - d * 5.0])
	shape(cv, band, Color("1d1d22"), st, true, 2.0)
	flutter(cv, a - n * 12.0 * k, -40.0, 22.0, 4.0, 2.5, Color("1d1d22"), st, 0.3, 3)
	flutter(cv, a - n * 12.0 * k, -15.0, 18.0, 3.5, 2.0, Color("1d1d22"), st, 1.9, 3)


func draw_leg_extra(cv: CanvasItem, J: Dictionary, _p: Dictionary, s: String, st: Dictionary) -> void:
	if s != "f":
		return
	var side := Vector2(1, 0).rotated(J.torso_ang)
	var up := Vector2(0, -1).rotated(J.torso_ang)
	var ch: float = dims.chest
	# front coat skirt panel with bright green wave/cloud trim along the hem
	var f_root: Vector2 = J.hip + side * 11.5 * ch + up * 12.0
	flutter(cv, f_root, 6.0, 80.0, 11.0, 8.5, GREEN_COAT, st, 1.1, 5)
	flutter(cv, f_root + side * 2.5, 6.0, 78.0, 3.2, 2.4, GREEN_TRIM, st, 1.1, 5)
	# cream waist sash tails hanging down the hip
	flutter(cv, J.hip - side * 12.0 * ch + up * 4.0, -8.0, 54.0, 6.8, 4.2, CREAM_SASH, st, 0.4, 4)
	flutter(cv, J.hip - side * 8.0 * ch + up * 6.0, 8.0, 44.0, 5.8, 3.8, CREAM_SASH, st, 1.6, 4)
	# three ornate katana scabbards hung at the right hip (crimson/black/white with gold fittings)
	var hip: Vector2 = J.hip + Vector2(-9, 3).rotated(J.torso_ang)
	var sc_cols := [CRIMSON, Color("f2f0e8"), Color("221a29")]
	for i in 3:
		var a: float = deg_to_rad(142.0 + i * 7.5) + float(J.torso_ang)
		var u := Vector2(cos(a), sin(a))
		var n := Vector2(-u.y, u.x)
		var p0 := hip + Vector2(-i * 3.5, i * 4.5)
		var p1 := p0 + u * 94.0
		shape(cv, PackedVector2Array([p0 + n * 3.4, p1 + n * 2.4, p1 - n * 2.4, p0 - n * 3.4]), sc_cols[i], st, true, 2.0)
		for f_u in [0.08, 0.3, 0.58, 0.94]:
			var gp := p0.lerp(p1, f_u)
			cv.draw_line(gp + n * 3.4, gp - n * 3.4, fc(GOLD, st), 2.3, true)


func draw_hair_back(cv: CanvasItem, R: float, _p: Dictionary, st: Dictionary) -> void:
	spikes(cv, R * 0.96, 110.0, 195.0, 6, R * 0.44, col.hair.darkened(0.08), st, 0.35, Vector2(-3, 0), 5, 18.0)


func draw_hair(cv: CanvasItem, R: float, _p: Dictionary, st: Dictionary) -> void:
	# sharp spiky marimo green hair with layered anime fringe
	spikes(cv, R * 0.98, 150.0, 348.0, 11, R * 0.38, col.hair, st, 0.42, Vector2(0, -R * 0.14), 11, -20.0)
	var fr := local_pts(Vector2.ZERO, Vector2.RIGHT, Vector2.DOWN, R, [[-0.14, -1.04], [0.64, -1.0], [1.04, -0.64], [0.84, -0.52], [0.7, -0.64], [0.52, -0.48], [0.36, -0.64], [0.16, -0.5], [-0.04, -0.7]])
	shape(cv, fr, col.hair, st, true, 2.3)


func draw_face_extra(cv: CanvasItem, R: float, _p: Dictionary, st: Dictionary) -> void:
	# three gold drop earrings on the left ear
	for i in 3:
		var e := Vector2(-R * 0.52 + i * 1.8, R * 0.32 + i * R * 0.08)
		cv.draw_line(e, e + Vector2(0, R * 0.16), fc(GOLD, st), 2.2, true)
		cv.draw_circle(e + Vector2(0, R * 0.16), 1.5, fc(GOLD, st).lightened(0.25))
	# vertical scar over the far (left) eye
	var ex := EYE_FAR.x * R
	cv.draw_line(Vector2(ex + 2.0, -R * 0.42), Vector2(ex - 1.5, R * 0.38), Color("7a3530"), 2.1, true)


func draw_head_extra(cv: CanvasItem, J: Dictionary, p: Dictionary, st: Dictionary) -> void:
	# third sword held in the mouth (Wado Ichimonji, white hilt)
	var R: float = dims.head
	xf(cv, J.head, J.head_ang)
	var m := Vector2(R * 0.46, R * 0.66)
	var ang := deg_to_rad(float(p.get("ma", 8.0)))
	var v := Vector2(cos(ang), sin(ang))
	_draw_blade(cv, m - v * 4.0, v, 96.0, Color("f4f1e8"), st, 14.0)
	xf_reset(cv)


func draw_sword(cv: CanvasItem, J: Dictionary, _p: Dictionary, s: String, st: Dictionary) -> void:
	var hand: Vector2 = J["hand_" + s]
	var tip: Vector2 = J["tip_" + s]
	var v := (tip - hand).normalized()
	var handle := Color("5a2d82") if s == "f" else CRIMSON
	_draw_blade(cv, hand - v * 20.0, v, hand.distance_to(tip) + 20.0, handle, st)


func _draw_blade(cv: CanvasItem, start: Vector2, v: Vector2, length: float, handle: Color, st: Dictionary, grip := 34.0) -> void:
	var n := Vector2(-v.y, v.x)
	var grip_end := start + v * grip
	shape(cv, capsule(start, grip_end, 4.6, 4.6, 3), handle, st, false, 1.8)
	# gold kashira pommel cap
	shape(cv, ellipse(start, 3.6, 4.6, 8, v.angle()), GOLD, st, false, 1.5)
	# diamond tsuka-ito wrap pattern with gold menuki
	for i in int(grip / 9.0):
		var c := start + v * (7.0 + i * 8.0)
		cv.draw_line(c - n * 4.2, c + n * 4.2, fc(GOLD if i == 1 else handle.darkened(0.55), st), 1.5, true)
	var guard := grip_end + v * 2.0
	shape(cv, ellipse(guard, 4.0, 9.8, 10, v.angle()), GOLD, st, false, 1.8)
	var b0 := guard + v * 3.0
	var tip := start + v * length
	var pts := PackedVector2Array()
	var steps := 8
	for i in steps + 1:
		var u := float(i) / steps
		var curve := sin(u * PI * 0.9) * 6.0
		var w := lerpf(3.8, 0.6, pow(u, 3.0))
		pts.append(b0.lerp(tip, u) + n * (curve + w))
	for i in range(steps, -1, -1):
		var u := float(i) / steps
		var curve := sin(u * PI * 0.9) * 6.0
		var w := lerpf(3.8, 0.6, pow(u, 3.0))
		pts.append(b0.lerp(tip, u) + n * (curve - w))
	if not Geometry2D.triangulate_polygon(pts).is_empty():
		cv.draw_colored_polygon(pts, fc(Color("d8e2ec"), st))
	outline(cv, pts, 1.6)
	var edge := PackedVector2Array()
	for i in steps + 1:
		var u := float(i) / steps
		edge.append(b0.lerp(tip, u) + n * (sin(u * PI * 0.9) * 6.0 - 1.5))
	cv.draw_polyline(edge, Color(1, 1, 1, 0.92), 1.5, true)


func draw_back_fx(cv: CanvasItem, J: Dictionary, p: Dictionary, st: Dictionary) -> void:
	# flowing dark-green coat tails behind the legs with bright green trim border
	coat_tail(cv, J, st, GREEN_COAT, false, 88.0, 22.0)
	var side := Vector2(1, 0).rotated(J.torso_ang)
	var up := Vector2(0, -1).rotated(J.torso_ang)
	var ch: float = dims.chest
	var b_root: Vector2 = J.hip - side * 12.0 * ch + up * 28.0
	flutter(cv, b_root + side * 8.0, -10.0, 112.0, 3.5, 2.5, GREEN_TRIM, st, 0.2, 5)
	if p.get("fx", "") != "ashura":
		return
	var tt: float = st.get("time", 0.0)
	var c := Color(0.55, 0.25, 0.85, 0.28 + 0.08 * sin(tt * 9.0))
	var center: Vector2 = J.neck + Vector2(-10, 10)
	cv.draw_circle(center, 120.0, Color(0.3, 0.1, 0.5, 0.18))
	# ghost heads and arms of Asura
	for s_dir in [-1, 1]:
		var hpos: Vector2 = J.head + Vector2(s_dir * 38.0, 8.0)
		cv.draw_circle(hpos, dims.head * 0.95, c)
		for k in 2:
			var sh: Vector2 = J.shoulder + Vector2(s_dir * 14.0, 10.0 + k * 22.0)
			var a := deg_to_rad(s_dir * 70.0 + k * 25.0 * s_dir + sin(tt * 5.0 + k) * 8.0 - 90.0)
			var hand := sh + Vector2(cos(a), sin(a)) * 80.0
			cv.draw_line(sh, hand, c, 12.0, true)
			var tip := hand + Vector2(cos(a - 0.5 * s_dir), sin(a - 0.5 * s_dir)) * 110.0
			cv.draw_line(hand, tip, Color(0.85, 0.75, 1.0, 0.45), 4.0, true)


func update_fx(f, fx) -> void:
	if String(f.pose.get("fx", "")) == "aura_g" and Engine.get_physics_frames() % 2 == 0:
		fx.smoke(f.world_point(f.J.hip) + Vector2(randf_range(-60, 60), randf_range(-150, 20)), Color(0.3, 0.8, 0.45, 0.45), 1.4)
	if String(f.pose.get("fx", "")) == "ashura" and Engine.get_physics_frames() % 2 == 0:
		var pos: Vector2 = f.world_point(f.J.hip) + Vector2(randf_range(-60, 60), randf_range(-150, 20))
		fx.smoke(pos, Color(0.45, 0.2, 0.7, 0.45), 1.6)


# ---------------------------------------------------------------- more moves

func more_moves() -> void:
	moves.s2_h = {
		"title": "Nitoryu: TAKA NAMI!",
		"anim": [[12, {"t": -10.0, "ua_f": 120.0, "fa_f": 200.0, "sa_f": 250.0, "ua_b": 110.0, "fa_b": 190.0, "sa_b": 240.0, "face": "angry"}],
			[4, {"base": "crouch", "t": 40.0, "head": -20.0, "ua_f": 60.0, "fa_f": 40.0, "sa_f": 10.0, "ua_b": 50.0, "fa_b": 30.0, "sa_b": 20.0, "face": "shout"}],
			[12, {"base": "crouch", "t": 40.0, "head": -20.0, "ua_f": 60.0, "fa_f": 40.0, "sa_f": 10.0, "ua_b": 50.0, "fa_b": 30.0, "sa_b": 20.0, "face": "shout"}], [12, "idle"]],
		"proj": [[14, {"type": "wave", "pos": [110, -40], "vel": [10, 0], "r": 44.0, "life": 70, "hp": 2,
			"hit": {"dmg": 80.0, "stun": 20, "bstun": 14, "kb": 5.0, "lvl": "low", "lift": -8.0, "kd": true, "hs": 9, "spark": "slash", "sfx": "slash_h", "chip": 0.1}}]],
		"sfx": [[12, "swing_h"], [13, "wind"]], "trail": "sword_f", "fx": [[14, "dust", [110, 0]]],
	}
	moves.s3_h = {
		"title": "Santoryu: TORA GARI!",
		"anim": [[6, {"base": "crouch"}], [10, {"base": "jump", "t": -10.0, "ua_f": 160.0, "fa_f": 200.0, "sa_f": 230.0, "ua_b": 150.0, "fa_b": 190.0, "sa_b": 220.0, "face": "angry"}],
			[4, {"t": 40.0, "head": -20.0, "ua_f": 80.0, "fa_f": 60.0, "sa_f": 40.0, "ua_b": 70.0, "fa_b": 50.0, "sa_b": 30.0, "th_f": 60.0, "sh_f": 0.0, "face": "shout"}],
			[14, {"t": 40.0, "head": -20.0, "ua_f": 70.0, "fa_f": 40.0, "sa_f": 20.0, "ua_b": 60.0, "fa_b": 30.0, "sa_b": 10.0, "th_f": 60.0, "sh_f": 0.0, "face": "shout"}], [12, "crouch"]],
		"hits": [{"f": [16, 28], "seg": "sword_f", "r": 30.0, "dmg": 140.0, "stun": 26, "bstun": 18, "kb": 6.0, "lvl": "high", "kd": true, "hs": 15, "spark": "slash", "sfx": "slash_h", "chip": 0.12}],
		"vel": [[6, 8.0, -16.0]], "sfx": [[5, "jump"], [15, "swing_h"]], "trail": "sword_f", "shake_at": [[24, 6.0]],
	}
	moves.s4 = {
		"title": "Ittoryu: SHISHI SONSON!",
		"anim": [[14, {"t": 20.0, "head": -10.0, "ua_f": 30.0, "fa_f": 60.0, "sa_f": 250.0, "ua_b": 20.0, "fa_b": 80.0, "sa_b": 260.0, "th_f": 70.0, "sh_f": 0.0, "th_b": -40.0, "sh_b": -40.0, "face": "closed"}],
			[6, {"t": 34.0, "head": -20.0, "ua_f": 95.0, "fa_f": 92.0, "sa_f": 92.0, "ua_b": -40.0, "fa_b": -20.0, "sa_b": 200.0, "th_f": 80.0, "sh_f": 0.0, "th_b": -60.0, "sh_b": -70.0, "face": "attack"}],
			[18, {"t": 10.0, "head": -10.0, "ua_f": 100.0, "fa_f": 95.0, "sa_f": 95.0, "ua_b": -30.0, "fa_b": -10.0, "sa_b": 200.0, "th_f": 50.0, "sh_f": -10.0, "face": "angry"}], [10, "idle"]],
		"hits": [{"f": [15, 20], "seg": "pts", "pts": [[-60, -140], [100, -140]], "r": 50.0, "dmg": 150.0, "stun": 28, "bstun": 18, "kb": 6.0, "lift": -10.0, "kd": true, "hs": 18, "spark": "slash", "sfx": "slash_h", "chip": 0.12}],
		"vel": [[15, 30.0], [21, 2.0]], "slide": true, "pass": true, "ghost": true, "sfx": [[13, "dash"], [15, "swing_h"]], "trail": "sword_f", "fx": [[21, "slash_x", [-140, -140]]],
	}
	var spin := []
	for k in 4:
		spin.append([6, {"t": 30.0, "rot": -180.0 * (k + 1), "ua_f": 90.0, "fa_f": 90.0, "sa_f": 180.0 * ((k + 1) % 2), "ua_b": 90.0, "fa_b": 90.0, "sa_b": 180.0 * (k % 2), "face": "shout"}])
	moves.super2 = {
		"title": "Santoryu Ogi: SANZEN SEKAI!",
		"super": true,
		"anim": [[22, {"t": 10.0, "head": -10.0, "ua_f": 60.0, "fa_f": 160.0, "sa_f": 200.0, "ua_b": 50.0, "fa_b": 150.0, "sa_b": 190.0, "face": "angry", "fx": "aura_g"}]] + spin
			+ [[20, {"t": 30.0, "head": -20.0, "ua_f": 100.0, "fa_f": 95.0, "sa_f": 95.0, "ua_b": 80.0, "fa_b": 70.0, "sa_b": 70.0, "th_f": 70.0, "sh_f": 0.0, "th_b": -50.0, "sh_b": -60.0, "face": "shout"}], [12, "idle"]],
		"hits": multi(24, 8, 3, {"seg": "pts", "pts": [[-40, -150], [140, -150]], "r": 80.0, "dmg": 18.0, "stun": 26, "bstun": 9, "kb": 1.0, "hs": 3, "spark": "slash", "sfx": "slash_l", "chip": 0.15},
			{"dmg": 140.0, "kb": 14.0, "lift": -14.0, "kd": true, "hs": 20, "sfx": "slash_h"}),
		"vel": [[23, 14.0], [47, 2.0]], "slide": true, "pass": true, "invuln": [1, 24], "trail": "sword_f", "zoom": true,
		"sfx": [[2, "aura"], [22, "dash"], [24, "swing_h"], [30, "swing_h"], [36, "swing_h"], [44, "slash_h"]], "fx": [[47, "slash_x", [-80, -150]]],
	}
