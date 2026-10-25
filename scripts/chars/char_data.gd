class_name CharData
extends RefCounted
## Base class for a fighter: body proportions, colors, poses, moves and the
## procedural "cel shaded" renderer. Subclasses override setup() and the
## draw hooks (hair, hat, clothes, weapons, effects).
##
## Pose angles are in degrees. Limb angles use dir(a) = (sin a, cos a):
## 0 points down, 90 forward (toward the opponent), 180 up, -90 backward.
## Torso "t" is the lean from upright (positive leans forward).

const OUTLINE := Color(0.09, 0.06, 0.08)
const LIGHT := Vector2(0.55, -0.83)

var id := ""
var display_name := ""
var epithet := ""
var quote := ""
var accent := Color(0.8, 0.2, 0.2)
var trail_color := Color(1, 1, 1)

var dims := {
	"thigh": 56.0, "shin": 56.0, "torso": 78.0, "neck": 8.0, "head": 25.0,
	"ua": 41.0, "fa": 39.0, "foot": 22.0, "sword": 118.0, "chest": 1.0,
	"limb": 1.0,
}
var col := {
	"skin": Color("f2c49b"), "hair": Color("222222"), "top": Color("ffffff"),
	"pants": Color("2e4f8f"), "shoes": Color("3a2a20"), "sash": Color(0, 0, 0, 0),
	"eye": Color("1d1d1d"),
}
## top: "none" (bare chest), "vest" (open vest), "shirt", "suit"
## sleeves: "none", "short", "long".  pants: "short", "knee", "long".  feet: "sandal", "boot", "shoe"
var style := {"top": "shirt", "sleeves": "short", "pants": "long", "feet": "shoe", "cuff": false}

var walk_speed := 4.4
var back_speed := 3.4
var jump_vy := -19.5
var jump_vx := 5.2
var dash_speed := 13.0
var max_hp := 1000.0
var has_swords := false
var ai_zoner := false

var poses := {}
var moves := {}
var _resolved := {}

const BASE := {
	"hx": 0.0, "hy": 0.0, "t": 8.0, "head": -6.0, "rot": 0.0,
	"ua_f": 30.0, "fa_f": 140.0, "ua_b": 12.0, "fa_b": 120.0,
	"th_f": 26.0, "sh_f": -2.0, "th_b": -18.0, "sh_b": -26.0,
	"st_f": 1.0, "st_b": 1.0, "sl_f": 1.0, "sl_b": 1.0,
	"sa_f": 100.0, "sa_b": 110.0, "face": "normal", "fx": "",
}


func _init() -> void:
	_base_poses()
	setup()
	_finalize()


## Override: set dims, colors, poses and moves.
func setup() -> void:
	pass


# ---------------------------------------------------------------- poses

func _base_poses() -> void:
	poses = {
		"idle": {},
		"idle_b": {"hy": 3.0, "t": 11.0, "ua_f": 34.0, "fa_f": 136.0, "ua_b": 16.0, "th_f": 29.0, "sh_f": -6.0, "th_b": -20.0, "sh_b": -24.0},
		"walk1": {"th_f": 36.0, "sh_f": 6.0, "th_b": -28.0, "sh_b": -30.0, "t": 10.0},
		"walk2": {"th_f": 12.0, "sh_f": -32.0, "th_b": -6.0, "sh_b": -12.0, "t": 9.0, "hy": -4.0},
		"crouch": {"t": 24.0, "head": -18.0, "th_f": 84.0, "sh_f": -6.0, "th_b": 30.0, "sh_b": -78.0, "ua_f": 50.0, "fa_f": 150.0, "ua_b": 30.0, "fa_b": 130.0},
		"jump": {"t": 14.0, "head": -10.0, "th_f": 100.0, "sh_f": 6.0, "th_b": 55.0, "sh_b": -30.0, "ua_f": 60.0, "fa_f": 150.0, "ua_b": -20.0, "fa_b": 60.0},
		"jump_up": {"t": 4.0, "th_f": 40.0, "sh_f": -10.0, "th_b": -10.0, "sh_b": -20.0, "ua_f": 150.0, "fa_f": 160.0, "ua_b": -30.0, "fa_b": -10.0},
		"guard": {"t": -4.0, "head": 6.0, "ua_f": 70.0, "fa_f": 175.0, "ua_b": 55.0, "fa_b": 165.0, "th_f": 22.0, "sh_f": 8.0, "th_b": -24.0, "sh_b": -24.0, "face": "angry"},
		"guard_low": {"base": "crouch", "ua_f": 75.0, "fa_f": 170.0, "ua_b": 60.0, "fa_b": 160.0, "face": "angry"},
		"hurt": {"t": -22.0, "head": -26.0, "ua_f": -10.0, "fa_f": 30.0, "ua_b": -40.0, "fa_b": -10.0, "th_f": 20.0, "sh_f": 10.0, "th_b": -14.0, "sh_b": -30.0, "face": "hurt"},
		"hurt2": {"t": 28.0, "head": 20.0, "ua_f": 10.0, "fa_f": 0.0, "ua_b": -10.0, "fa_b": -20.0, "th_f": 14.0, "sh_f": -10.0, "th_b": -20.0, "sh_b": -24.0, "face": "hurt"},
		"hurt_low": {"base": "crouch", "t": -6.0, "head": -26.0, "ua_f": -10.0, "fa_f": 40.0, "face": "hurt"},
		"air_hurt": {"t": -30.0, "head": -30.0, "rot": -20.0, "ua_f": -60.0, "fa_f": -30.0, "ua_b": -100.0, "fa_b": -60.0, "th_f": 50.0, "sh_f": 20.0, "th_b": 20.0, "sh_b": -10.0, "face": "hurt"},
		"down": {"rot": -88.0, "t": 0.0, "head": -10.0, "ua_f": 40.0, "fa_f": 80.0, "ua_b": -50.0, "fa_b": -20.0, "th_f": 10.0, "sh_f": 0.0, "th_b": -6.0, "sh_b": -6.0, "face": "ko"},
		"getup": {"base": "crouch", "t": 30.0, "face": "angry"},
		"dash": {"t": 32.0, "head": -26.0, "ua_f": -40.0, "fa_f": 0.0, "ua_b": -60.0, "fa_b": -20.0, "th_f": 70.0, "sh_f": 0.0, "th_b": -40.0, "sh_b": -60.0},
		"backdash": {"t": -16.0, "head": 10.0, "ua_f": 40.0, "fa_f": 150.0, "th_f": 40.0, "sh_f": 20.0, "th_b": -10.0, "sh_b": -40.0},
		"land": {"base": "crouch", "t": 16.0},
		"win": {"t": 0.0, "head": -12.0, "ua_f": 160.0, "fa_f": 175.0, "ua_b": -30.0, "fa_b": 20.0, "th_f": 12.0, "sh_f": 4.0, "th_b": -10.0, "sh_b": -6.0, "face": "grin"},
		"lose": {"base": "crouch", "t": 46.0, "head": 30.0, "ua_f": 10.0, "fa_f": 0.0, "ua_b": 0.0, "fa_b": 0.0, "face": "hurt"},
		"intro": {"t": 0.0, "head": -4.0, "ua_f": -8.0, "fa_f": 10.0, "ua_b": 8.0, "fa_b": -8.0, "th_f": 8.0, "sh_f": 0.0, "th_b": -8.0, "sh_b": -2.0},
		"shout": {"t": -6.0, "head": -16.0, "face": "shout"},
	}


func pose(spec) -> Dictionary:
	if spec is String:
		if _resolved.has(spec):
			return _resolved[spec]
		var r := pose(poses.get(spec, {}))
		_resolved[spec] = r
		return r
	var d: Dictionary = spec
	var out: Dictionary
	if d.has("base"):
		out = pose(String(d.base)).duplicate()
	else:
		out = BASE.duplicate()
		_apply(out, poses.get("idle", {}))
	_apply(out, d)
	return out


static func _apply(out: Dictionary, d: Dictionary) -> void:
	for k in d:
		if k != "base":
			var v = d[k]
			if v is int:
				v = float(v)
			out[k] = v


static func lerp_pose(a: Dictionary, b: Dictionary, u: float) -> Dictionary:
	var out := {}
	for k in b:
		var bv = b[k]
		var av = a.get(k, bv)
		if bv is float and av is float:
			out[k] = lerpf(av, bv, u)
		else:
			out[k] = bv if u > 0.35 else av
	return out


# ---------------------------------------------------------------- moves

const HIT_DEFAULTS := {
	"seg": "hand_f", "r": 18.0, "dmg": 50.0, "stun": 16, "bstun": 12, "kb": 5.0,
	"lvl": "mid", "hs": 7, "spark": "punch", "sfx": "hit_m", "kd": false,
	"chip": 0.0, "lift": 0.0,
}


func _finalize() -> void:
	for name in moves:
		var m: Dictionary = moves[name]
		var anim := []
		var total := 0
		for k in m.anim:
			anim.append([int(k[0]), pose(k[1])])
			total += int(k[0])
		m["keys"] = anim
		if not m.has("total"):
			m["total"] = total
		var hits := []
		var i := 0
		for h in m.get("hits", []):
			var d := HIT_DEFAULTS.duplicate()
			d.merge(h, true)
			d["id"] = i
			i += 1
			hits.append(d)
		m["hits"] = hits
		m["name"] = name


## Helper to repeat a hit every few frames (gatlings, spins).
static func multi(start: int, count: int, every: int, h: Dictionary, last := {}) -> Array:
	var out := []
	for i in count:
		var d := h.duplicate()
		var s := start + i * every
		d["f"] = [s, s + 1]
		if i == count - 1:
			d.merge(last, true)
		out.append(d)
	return out


# ---------------------------------------------------------------- skeleton

static func dir(a: float) -> Vector2:
	var r := deg_to_rad(a)
	return Vector2(sin(r), cos(r))


## Joint positions in fighter-local space (facing right, y down, origin on the ground).
func joints(p: Dictionary, grounded := true) -> Dictionary:
	var D := dims
	var J := {}
	var hip := Vector2(p.hx, p.hy - (D.thigh + D.shin) * 0.95)
	var t := deg_to_rad(p.t)
	var tdir := Vector2(sin(t), -cos(t))
	var neck: Vector2 = hip + tdir * D.torso
	var sh: Vector2 = neck - tdir * 9.0
	var ha := deg_to_rad(p.t + p.head)
	var head: Vector2 = neck + Vector2(sin(ha), -cos(ha)) * (D.neck + D.head * 0.85)
	J.hip = hip
	J.neck = neck
	J.shoulder = sh
	J.head = head
	J.elbow_f = sh + dir(p.ua_f) * D.ua * p.st_f
	J.hand_f = J.elbow_f + dir(p.fa_f) * D.fa * p.st_f
	J.elbow_b = sh + dir(p.ua_b) * D.ua * p.st_b
	J.hand_b = J.elbow_b + dir(p.fa_b) * D.fa * p.st_b
	J.knee_f = hip + dir(p.th_f) * D.thigh * p.sl_f
	J.foot_f = J.knee_f + dir(p.sh_f) * D.shin * p.sl_f
	J.toe_f = J.foot_f + dir(p.sh_f + 90.0) * D.foot
	J.knee_b = hip + dir(p.th_b) * D.thigh * p.sl_b
	J.foot_b = J.knee_b + dir(p.sh_b) * D.shin * p.sl_b
	J.toe_b = J.foot_b + dir(p.sh_b + 90.0) * D.foot
	if has_swords:
		J.tip_f = J.hand_f + dir(p.sa_f) * D.sword
		J.tip_b = J.hand_b + dir(p.sa_b) * D.sword
	var rot: float = p.rot
	if rot != 0.0:
		var rr := deg_to_rad(rot)
		for k in J:
			J[k] = hip + (J[k] - hip).rotated(rr)
	J.torso_ang = deg_to_rad(p.t + rot)
	J.head_ang = deg_to_rad(p.t + p.head + rot)
	if grounded:
		var low := -9999.0
		for k in ["foot_f", "foot_b", "toe_f", "toe_b"]:
			low = maxf(low, J[k].y + 5.0)
		for k in ["knee_f", "knee_b", "hand_f", "hand_b"]:
			low = maxf(low, J[k].y + 9.0)
		low = maxf(low, J.hip.y + 16.0)
		low = maxf(low, J.neck.y + 18.0)
		low = maxf(low, J.head.y + D.head)
		var off := Vector2(0, -low)
		for k in J:
			if J[k] is Vector2:
				J[k] += off
	return J


## Hurt capsules [a, b, r] in local space.
func hurt_caps(J: Dictionary) -> Array:
	return [
		[J.hip, J.neck, 25.0 * dims.chest],
		[J.head, J.head, dims.head + 2.0],
		[J.hip, J.knee_f, 14.0], [J.knee_f, J.foot_f, 12.0],
		[J.hip, J.knee_b, 14.0], [J.knee_b, J.foot_b, 12.0],
		[J.shoulder, J.elbow_f, 10.0], [J.elbow_f, J.hand_f, 10.0],
		[J.shoulder, J.elbow_b, 9.0],
	]


## Segment for an attack definition, in local space.
func hit_seg(h: Dictionary, J: Dictionary) -> Array:
	var r: float = h.r
	match String(h.seg):
		"hand_f": return [J.elbow_f.lerp(J.hand_f, 0.4), J.hand_f, r]
		"hand_b": return [J.elbow_b.lerp(J.hand_b, 0.4), J.hand_b, r]
		"arm_f": return [J.shoulder.lerp(J.hand_f, 0.3), J.hand_f, r]
		"arm_b": return [J.shoulder.lerp(J.hand_b, 0.3), J.hand_b, r]
		"foot_f": return [J.knee_f.lerp(J.foot_f, 0.4), J.toe_f, r]
		"foot_b": return [J.knee_b.lerp(J.foot_b, 0.4), J.toe_b, r]
		"leg_f": return [J.knee_f, J.toe_f, r]
		"leg_b": return [J.knee_b, J.toe_b, r]
		"sword_f": return [J.hand_f.lerp(J.tip_f, 0.25), J.tip_f, r]
		"sword_b": return [J.hand_b.lerp(J.tip_b, 0.25), J.tip_b, r]
		"body": return [J.hip, J.neck, r]
		"head": return [J.head, J.head, r]
		"hip": return [J.hip, J.hip, r]
		_:
			var pts: Array = h.get("pts", [[0, -100], [60, -100]])
			return [Vector2(pts[0][0], pts[0][1]), Vector2(pts[1][0], pts[1][1]), r]


## Which segment draws a motion trail for the current pose ("" for none).
func trail_points(seg: String, J: Dictionary) -> Array:
	match seg:
		"sword_f": return [J.hand_f.lerp(J.tip_f, 0.2), J.tip_f]
		"sword_b": return [J.hand_b.lerp(J.tip_b, 0.2), J.tip_b]
		"hand_f", "arm_f": return [J.elbow_f, J.hand_f]
		"hand_b", "arm_b": return [J.elbow_b, J.hand_b]
		"foot_f", "leg_f": return [J.knee_f, J.toe_f]
		"foot_b", "leg_b": return [J.knee_b, J.toe_b]
	return []


# ---------------------------------------------------------------- drawing helpers

static func capsule(a: Vector2, b: Vector2, ra: float, rb: float, n := 7) -> PackedVector2Array:
	var d := b - a
	var ang := 0.0
	if d.length() > 0.01:
		ang = d.angle()
	var pts := PackedVector2Array()
	for i in n + 1:
		var t := ang - PI / 2.0 + PI * float(i) / n
		pts.append(b + Vector2(cos(t), sin(t)) * rb)
	for i in n + 1:
		var t := ang + PI / 2.0 + PI * float(i) / n
		pts.append(a + Vector2(cos(t), sin(t)) * ra)
	return pts


static func ellipse(c: Vector2, rx: float, ry: float, n := 18, rot := 0.0) -> PackedVector2Array:
	var pts := PackedVector2Array()
	for i in n:
		var t := TAU * float(i) / n
		pts.append(c + Vector2(cos(t) * rx, sin(t) * ry).rotated(rot))
	return pts


static func outline(cv: CanvasItem, pts: PackedVector2Array, w := 2.4, c := OUTLINE) -> void:
	var closed := pts.duplicate()
	closed.append(pts[0])
	cv.draw_polyline(closed, c, w, true)


func fc(c: Color, st: Dictionary) -> Color:
	var out := c
	if st.get("far", false):
		out = out.darkened(0.22)
	var tint: Color = st.get("tint", Color(0, 0, 0, 0))
	if tint.a > 0.0:
		out = out.lerp(Color(tint.r, tint.g, tint.b), tint.a)
	var fl: float = st.get("flash", 0.0)
	if fl > 0.0:
		out = out.lerp(Color.WHITE, fl)
	out.a = c.a
	return out


## Filled, cel shaded polygon with an outline.
func shape(cv: CanvasItem, pts: PackedVector2Array, c: Color, st: Dictionary, shade := true, w := 2.4) -> void:
	if pts.size() < 3:
		return
	var base := fc(c, st)
	if Geometry2D.triangulate_polygon(pts).is_empty():
		outline(cv, pts, w)
		return
	if shade:
		cv.draw_colored_polygon(pts, base.darkened(0.28))
		var cen := Vector2.ZERO
		for p in pts:
			cen += p
		cen /= pts.size()
		var inner := PackedVector2Array()
		for p in pts:
			var v := p - cen
			var l := v.length()
			var s := maxf(l - 3.2, l * 0.55)
			inner.append(cen + v.normalized() * s + LIGHT * 1.6)
		if Geometry2D.triangulate_polygon(inner).is_empty():
			cv.draw_colored_polygon(pts, base)
		else:
			cv.draw_colored_polygon(inner, base)
	else:
		cv.draw_colored_polygon(pts, base)
	outline(cv, pts, w)


func limb(cv: CanvasItem, a: Vector2, b: Vector2, ra: float, rb: float, c: Color, st: Dictionary) -> void:
	var lim: float = dims.limb
	shape(cv, capsule(a, b, ra * lim, rb * lim), c, st)


# ---------------------------------------------------------------- renderer

## st: {flash, tint, time, far, aura, fighter}
func draw(cv: CanvasItem, J: Dictionary, p: Dictionary, st: Dictionary) -> void:
	draw_back_fx(cv, J, p, st)
	var far := st.duplicate()
	far.far = true
	draw_arm(cv, J, p, "b", far)
	draw_leg(cv, J, p, "b", far)
	draw_torso(cv, J, p, st)
	draw_leg(cv, J, p, "f", st)
	draw_head_all(cv, J, p, st)
	draw_arm(cv, J, p, "f", st)
	draw_front_fx(cv, J, p, st)


func draw_arm(cv: CanvasItem, J: Dictionary, p: Dictionary, s: String, st: Dictionary) -> void:
	var sh: Vector2 = J.shoulder + Vector2(3.0 if s == "f" else -3.0, 2.0).rotated(J.torso_ang)
	var el: Vector2 = J["elbow_" + s]
	var ha: Vector2 = J["hand_" + s]
	if has_swords and s == "b":
		draw_sword(cv, J, p, s, st)
	var upper: Color = col.skin
	var lower: Color = col.skin
	match String(style.sleeves):
		"short": upper = col.get("sleeve", col.top)
		"long":
			upper = col.get("sleeve", col.top)
			lower = upper
	limb(cv, sh, el, 11.0, 9.5, upper, st)
	limb(cv, el, ha, 9.5, 8.0, lower, st)
	draw_arm_extra(cv, J, p, s, st)
	# fist
	var fd := (ha - el).normalized()
	shape(cv, ellipse(ha + fd * 4.0, 10.5 * dims.limb, 9.0 * dims.limb, 12, fd.angle()), col.get("glove", col.skin), st)
	if has_swords and s == "f":
		draw_sword(cv, J, p, s, st)


func draw_leg(cv: CanvasItem, J: Dictionary, p: Dictionary, s: String, st: Dictionary) -> void:
	var hip: Vector2 = J.hip + Vector2(5.0 if s == "f" else -5.0, 0).rotated(J.torso_ang)
	var kn: Vector2 = J["knee_" + s]
	var ft: Vector2 = J["foot_" + s]
	var toe: Vector2 = J["toe_" + s]
	var pants: Color = col.pants
	var shin_c: Color = col.skin
	if style.pants == "long":
		shin_c = pants
	# foot first so the shin overlaps it
	var foot_c: Color = col.shoes
	if style.feet == "sandal":
		foot_c = col.skin
	shape(cv, capsule(ft, toe, 8.0, 6.5), foot_c, st)
	if style.feet == "sandal":
		var sole := capsule(ft + (ft - J["knee_" + s]).normalized() * 6.0, toe + (ft - J["knee_" + s]).normalized() * 5.0, 3.0, 3.0)
		shape(cv, sole, col.shoes, st, false, 1.6)
	limb(cv, kn, ft, 11.0, 8.5, shin_c, st)
	if style.feet == "boot":
		limb(cv, kn.lerp(ft, 0.45), ft, 10.5, 9.5, col.shoes, st)
	if style.pants == "knee":
		limb(cv, hip, kn.lerp(ft, 0.25), 16.0, 14.0, pants, st)
	elif style.pants == "short":
		limb(cv, hip, kn, 16.0, 15.0, pants, st)
	else:
		limb(cv, hip, kn, 15.0, 12.0, pants, st)
	if style.get("cuff", false):
		var c_end := kn
		if style.pants == "knee":
			c_end = kn.lerp(ft, 0.25)
		var d := (c_end - hip).normalized()
		var n: Vector2 = Vector2(-d.y, d.x) * 16.0 * float(dims.limb)
		var band := PackedVector2Array([c_end - d * 6.0 + n, c_end + d * 4.0 + n * 1.08, c_end + d * 4.0 - n * 1.08, c_end - d * 6.0 - n])
		shape(cv, band, col.get("cuff_c", Color.WHITE), st, false, 2.0)
	draw_leg_extra(cv, J, p, s, st)


func torso_pts(L: float, ch: float) -> PackedVector2Array:
	return PackedVector2Array([
		Vector2(-15, 8) * Vector2(ch, 1), Vector2(16, 8) * Vector2(ch, 1),
		Vector2(14 * ch, -L * 0.35), Vector2(20 * ch, -L * 0.68), Vector2(15 * ch, -L - 3),
		Vector2(-16 * ch, -L + 1), Vector2(-20 * ch, -L * 0.6), Vector2(-15 * ch, -L * 0.28),
	])


func draw_torso(cv: CanvasItem, J: Dictionary, p: Dictionary, st: Dictionary) -> void:
	var L: float = dims.torso
	var ch: float = dims.chest
	cv.draw_set_transform(J.hip, J.torso_ang, Vector2.ONE)
	var pts := torso_pts(L, ch)
	var base: Color = col.skin
	if style.top in ["shirt", "suit"]:
		base = col.top
	shape(cv, pts, base, st)
	if style.top == "none" or style.top == "vest":
		# simple muscle lines
		cv.draw_polyline(PackedVector2Array([Vector2(4, -L * 0.62), Vector2(14 * ch, -L * 0.55)]), fc(col.skin, st).darkened(0.35), 1.6, true)
		cv.draw_polyline(PackedVector2Array([Vector2(6, -L * 0.36), Vector2(8, -L * 0.18)]), fc(col.skin, st).darkened(0.3), 1.4, true)
	draw_torso_extra(cv, J, p, st, L, ch)
	if col.sash.a > 0.0:
		var sash := PackedVector2Array([Vector2(-17 * ch, 9), Vector2(18 * ch, 9), Vector2(16 * ch, -L * 0.22), Vector2(-17 * ch, -L * 0.2)])
		shape(cv, sash, col.sash, st)
	cv.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)


func draw_head_all(cv: CanvasItem, J: Dictionary, p: Dictionary, st: Dictionary) -> void:
	var R: float = dims.head
	limb(cv, J.neck + (J.neck - J.head).normalized() * 6.0, J.head + (J.neck - J.head).normalized() * R * 0.5, 9.0, 9.0, col.skin, st)
	draw_neck_extra(cv, J, p, st)
	cv.draw_set_transform(J.head, J.head_ang, Vector2.ONE)
	draw_hair_back(cv, R, p, st)
	draw_face(cv, R, p, st)
	draw_hair(cv, R, p, st)
	draw_hat(cv, R, p, st)
	cv.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	draw_head_extra(cv, J, p, st)


func head_pts(R: float) -> PackedVector2Array:
	var pts := PackedVector2Array()
	for i in 28:
		var a := TAU * float(i) / 28.0
		var chin := pow(maxf(0.0, cos(a - deg_to_rad(62.0))), 6.0)
		var r := R * (1.0 + 0.3 * chin)
		pts.append(Vector2(cos(a) * r * 0.94, sin(a) * r * 1.02))
	return pts


func draw_face(cv: CanvasItem, R: float, p: Dictionary, st: Dictionary) -> void:
	var face: String = p.get("face", "normal")
	# ear
	shape(cv, ellipse(Vector2(-R * 0.18, R * 0.08), R * 0.2, R * 0.26, 10), col.skin, st, false)
	shape(cv, head_pts(R), col.skin, st)
	cv.draw_arc(Vector2(-R * 0.18, R * 0.08), R * 0.1, -1.0, 2.0, 6, fc(col.skin, st).darkened(0.4), 1.5, true)
	var ink := OUTLINE
	var eye := Vector2(R * 0.5, -R * 0.02)
	match face:
		"hurt":
			cv.draw_polyline(PackedVector2Array([eye + Vector2(-R * 0.12, -R * 0.12), eye + Vector2(R * 0.08, 0), eye + Vector2(-R * 0.12, R * 0.12)]), ink, 2.6, true)
		"ko":
			cv.draw_line(eye + Vector2(-R * 0.1, -R * 0.1), eye + Vector2(R * 0.1, R * 0.1), ink, 2.6, true)
			cv.draw_line(eye + Vector2(-R * 0.1, R * 0.1), eye + Vector2(R * 0.1, -R * 0.1), ink, 2.6, true)
		"closed":
			cv.draw_arc(eye + Vector2(0, -R * 0.04), R * 0.13, 0.3, PI - 0.3, 6, ink, 2.4, true)
		_:
			draw_eye(cv, eye, R, face, st)
	# brow
	var brow_tilt := 0.0
	if face in ["angry", "shout", "attack"]:
		brow_tilt = R * 0.14
	draw_brow(cv, eye, R, brow_tilt, st)
	# nose
	cv.draw_line(Vector2(R * 0.96, R * 0.06), Vector2(R * 1.02, R * 0.2), fc(col.skin, st).darkened(0.45), 1.6, true)
	# mouth
	var m := Vector2(R * 0.72, R * 0.56)
	match face:
		"shout", "attack", "hurt":
			var o := PackedVector2Array([m + Vector2(-R * 0.22, -R * 0.08), m + Vector2(R * 0.12, -R * 0.12), m + Vector2(R * 0.08, R * 0.18), m + Vector2(-R * 0.14, R * 0.14)])
			cv.draw_colored_polygon(o, Color("6b1620"))
			cv.draw_line(o[0], o[1], Color.WHITE, 2.0, true)
			outline(cv, o, 1.8)
		"grin":
			var g := PackedVector2Array([m + Vector2(-R * 0.3, -R * 0.12), m + Vector2(R * 0.2, -R * 0.12), m + Vector2(R * 0.1, R * 0.14), m + Vector2(-R * 0.2, R * 0.08)])
			cv.draw_colored_polygon(g, Color.WHITE)
			cv.draw_line(g[0].lerp(g[3], 0.5), g[1].lerp(g[2], 0.5), Color(0.6, 0.6, 0.6), 1.0, true)
			outline(cv, g, 1.8)
		"ko":
			cv.draw_arc(m + Vector2(0, R * 0.12), R * 0.14, PI + 0.4, TAU - 0.4, 6, ink, 2.0, true)
		_:
			cv.draw_line(m + Vector2(-R * 0.2, 0), m + Vector2(R * 0.12, -R * 0.03), ink, 2.0, true)
	draw_face_extra(cv, R, p, st)


func draw_eye(cv: CanvasItem, eye: Vector2, R: float, face: String, st: Dictionary) -> void:
	var w := R * 0.15
	var h := R * 0.25
	if face in ["angry", "shout", "attack"]:
		h = R * 0.19
	cv.draw_colored_polygon(ellipse(eye, w, h, 12), Color.WHITE)
	cv.draw_colored_polygon(ellipse(eye + Vector2(w * 0.35, h * 0.08), w * 0.72, h * 0.8, 12), col.eye)
	cv.draw_circle(eye + Vector2(w * 0.55, -h * 0.35), R * 0.045, Color.WHITE)
	cv.draw_line(eye + Vector2(-w * 1.1, -h * 0.95), eye + Vector2(w * 1.3, -h * 0.85), OUTLINE, 3.0, true)


func draw_brow(cv: CanvasItem, eye: Vector2, R: float, tilt: float, st: Dictionary) -> void:
	cv.draw_line(eye + Vector2(-R * 0.22, -R * 0.38 - tilt * 0.4), eye + Vector2(R * 0.24, -R * 0.36 + tilt), fc(col.hair, st).darkened(0.2), 3.2, true)


# ---------------------------------------------------------------- hooks

func draw_hair_back(_cv: CanvasItem, _R: float, _p: Dictionary, _st: Dictionary) -> void:
	pass

func draw_hair(_cv: CanvasItem, _R: float, _p: Dictionary, _st: Dictionary) -> void:
	pass

func draw_hat(_cv: CanvasItem, _R: float, _p: Dictionary, _st: Dictionary) -> void:
	pass

func draw_face_extra(_cv: CanvasItem, _R: float, _p: Dictionary, _st: Dictionary) -> void:
	pass

func draw_head_extra(_cv: CanvasItem, _J: Dictionary, _p: Dictionary, _st: Dictionary) -> void:
	pass

func draw_neck_extra(_cv: CanvasItem, _J: Dictionary, _p: Dictionary, _st: Dictionary) -> void:
	pass

func draw_torso_extra(_cv: CanvasItem, _J: Dictionary, _p: Dictionary, _st: Dictionary, _L: float, _ch: float) -> void:
	pass

func draw_arm_extra(_cv: CanvasItem, _J: Dictionary, _p: Dictionary, _s: String, _st: Dictionary) -> void:
	pass

func draw_leg_extra(_cv: CanvasItem, _J: Dictionary, _p: Dictionary, _s: String, _st: Dictionary) -> void:
	pass

func draw_back_fx(_cv: CanvasItem, _J: Dictionary, _p: Dictionary, _st: Dictionary) -> void:
	pass

func draw_front_fx(_cv: CanvasItem, _J: Dictionary, _p: Dictionary, _st: Dictionary) -> void:
	pass

func draw_sword(_cv: CanvasItem, _J: Dictionary, _p: Dictionary, _s: String, _st: Dictionary) -> void:
	pass


## Spiky hair helper: a polygon of spikes along an arc of the skull.
func spikes(cv: CanvasItem, R: float, from_deg: float, to_deg: float, n: int, length: float, c: Color, st: Dictionary, jag := 0.35, center := Vector2.ZERO, seed := 1) -> void:
	var pts := PackedVector2Array()
	var rng := RandomNumberGenerator.new()
	rng.seed = seed
	pts.append(center)
	for i in n * 2 + 1:
		var u := float(i) / (n * 2)
		var a := deg_to_rad(lerpf(from_deg, to_deg, u))
		var r := R * 1.02
		if i % 2 == 1:
			r = R + length * (1.0 + rng.randf_range(-jag, jag))
		pts.append(center + Vector2(cos(a), sin(a)) * r)
	shape(cv, pts, c, st, true, 2.2)


## Called every frame while fighting so a character can emit particles (steam, flames).
func update_fx(_f, _fx) -> void:
	pass


## Whole-body color tint for the current pose (e.g. Gear Second pink).
func tint_for(_p: Dictionary) -> Color:
	return Color(0, 0, 0, 0)
