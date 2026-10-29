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
	_base_moves()
	setup()
	more_moves()
	_finalize()


## Override: set dims, colors, poses and moves.
func setup() -> void:
	pass


## Override: extra specials (s2_h, s3_h, s4) and the second super (super2).
func more_moves() -> void:
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


## Moves every fighter shares. Characters may replace them in setup().
func _base_moves() -> void:
	moves.throw = {
		"title": "THROW!",
		"anim": [[4, {"t": 20.0, "ua_f": 80.0, "fa_f": 90.0, "ua_b": 70.0, "fa_b": 85.0, "hand_f": "open", "hand_b": "open", "face": "angry"}],
			[8, {"t": 22.0, "ua_f": 84.0, "fa_f": 95.0, "ua_b": 76.0, "fa_b": 90.0, "face": "angry"}],
			[6, {"t": -26.0, "head": 14.0, "ua_f": 160.0, "fa_f": 170.0, "ua_b": 150.0, "fa_b": 165.0, "th_f": 40.0, "sh_f": 10.0, "th_b": -30.0, "sh_b": -30.0, "face": "shout"}],
			[8, {"t": 30.0, "head": -10.0, "ua_f": 70.0, "fa_f": 60.0, "ua_b": 60.0, "fa_b": 50.0, "th_f": 50.0, "sh_f": 0.0, "face": "shout"}], [12, "idle"]],
		"hits": [{"f": [3, 6], "seg": "pts", "pts": [[30, -150], [110, -150]], "r": 46.0, "dmg": 110.0, "stun": 30, "bstun": 0, "kb": 9.0, "lift": -15.0, "kd": true, "hs": 14, "spark": "heavy", "sfx": "hit_h", "throw": true}],
		"sfx": [[2, "swing_m"], [16, "swing_h"]], "shake_at": [[18, 6.0]],
	}


func pose(spec) -> Dictionary:
	if spec is String or spec is StringName:
		var key := String(spec)
		if _resolved.has(key):
			return _resolved[key]
		var r := pose(poses.get(key, {}))
		_resolved[key] = r
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

## Stage rim light (alpha is the strength). The fight sets it for each stage.
static var rim := Color(1.0, 0.82, 0.6, 0.45)
## Rotation of the current draw transform, so the light keeps one screen direction.
var _rot := 0.0


func xf(cv: CanvasItem, pos: Vector2, ang: float) -> void:
	cv.draw_set_transform(pos, ang, Vector2.ONE)
	_rot = ang


func xf_reset(cv: CanvasItem) -> void:
	xf(cv, Vector2.ZERO, 0.0)


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


## Points given in a local frame (x along u, y along v), scaled by k.
static func local_pts(o: Vector2, u: Vector2, v: Vector2, k: float, arr: Array) -> PackedVector2Array:
	var pts := PackedVector2Array()
	for q in arr:
		pts.append(o + u * float(q[0]) * k + v * float(q[1]) * k)
	return pts


## Muscle-shaped limb outline from a to b. front and back are (u, bulge):
## where along the bone the muscle peaks and how much it swells the radius.
static func muscle(a: Vector2, b: Vector2, ra: float, rb: float, front := Vector2(0.4, 0.0), back := Vector2(0.4, 0.0), n := 7) -> PackedVector2Array:
	var d := b - a
	var length := d.length()
	if length < 0.01:
		d = Vector2.DOWN
	else:
		d /= length
	var nf := Vector2(d.y, -d.x)
	var pts := PackedVector2Array()
	for i in n + 1:
		var u := float(i) / n
		var g := exp(-pow((u - front.x) / 0.26, 2.0))
		pts.append(a + d * length * u + nf * lerpf(ra, rb, u) * (1.0 + front.y * g))
	for i in range(1, 6):
		var t := PI * float(i) / 6.0
		pts.append(b + (nf * cos(t) + d * sin(t)) * rb)
	for i in range(n, -1, -1):
		var u := float(i) / n
		var g := exp(-pow((u - back.x) / 0.26, 2.0))
		pts.append(a + d * length * u - nf * lerpf(ra, rb, u) * (1.0 + back.y * g))
	for i in range(1, 6):
		var t := PI * float(i) / 6.0
		pts.append(a + (-nf * cos(t) - d * sin(t)) * ra)
	return pts


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


## Shadow tone: darker, slightly cooler and more saturated.
static func shadow_of(c: Color) -> Color:
	var s := c.darkened(0.32).lerp(Color(0.22, 0.1, 0.34), 0.14)
	s.a = c.a
	return s


static func _shift(pts: PackedVector2Array, v: Vector2) -> PackedVector2Array:
	var out := pts.duplicate()
	for i in out.size():
		out[i] += v
	return out


static func _fill(cv: CanvasItem, polys: Array, c: Color) -> void:
	for q in polys:
		var poly: PackedVector2Array = q
		if poly.size() >= 3 and not Geometry2D.triangulate_polygon(poly).is_empty():
			cv.draw_colored_polygon(poly, c)


## Filled polygon with cel shading (shadow, lit and highlight bands), a stage
## colored rim light on the shadow edge, and an ink outline.
func shape(cv: CanvasItem, pts: PackedVector2Array, c: Color, st: Dictionary, shade := true, w := 2.4, amt := 1.0) -> void:
	if pts.size() < 3:
		return
	var base := fc(c, st)
	if st.has("alpha"):
		# afterimage: one flat translucent silhouette
		if not Geometry2D.triangulate_polygon(pts).is_empty():
			cv.draw_colored_polygon(pts, Color(base.r, base.g, base.b, st.alpha))
		return
	if Geometry2D.triangulate_polygon(pts).is_empty():
		outline(cv, pts, w)
		return
	if not shade:
		cv.draw_colored_polygon(pts, base)
		outline(cv, pts, w)
		return
	var lo := pts[0]
	var hi := pts[0]
	for q in pts:
		lo = lo.min(q)
		hi = hi.max(q)
	var ext := minf(hi.x - lo.x, hi.y - lo.y) * 0.5
	var ld := LIGHT.rotated(-_rot)
	cv.draw_colored_polygon(pts, shadow_of(base))
	_fill(cv, Geometry2D.intersect_polygons(pts, _shift(pts, ld * clampf(ext * 0.55 * amt, 2.0, 11.0))), base)
	if ext > 5.0:
		var hl := base.lerp(Color(1.0, 0.98, 0.92), 0.22)
		hl.a = base.a
		_fill(cv, Geometry2D.clip_polygons(pts, _shift(pts, -ld * clampf(ext * 0.2, 1.4, 4.0))), hl)
	if rim.a > 0.0 and ext > 3.5:
		var rc := base.lerp(Color(rim.r, rim.g, rim.b), rim.a)
		rc.a = base.a
		_fill(cv, Geometry2D.clip_polygons(pts, _shift(pts, ld * 2.4)), rc)
	outline(cv, pts, w)


func limb(cv: CanvasItem, a: Vector2, b: Vector2, ra: float, rb: float, c: Color, st: Dictionary) -> void:
	var lim: float = dims.limb
	shape(cv, capsule(a, b, ra * lim, rb * lim), c, st)


## Loose cloth tube (sleeve, trouser leg) with a flared hem and fold lines.
func cloth(cv: CanvasItem, a: Vector2, b: Vector2, ra: float, rb: float, c: Color, st: Dictionary, flare := 1.12, folds := 2, seed := 0) -> void:
	shape(cv, muscle(a, b, ra, rb * flare, Vector2(0.55, 0.05), Vector2(0.5, 0.07), 6), c, st)
	var d := b - a
	var length := d.length()
	if length < 6.0 or folds <= 0:
		return
	d /= length
	var nf := Vector2(d.y, -d.x)
	var fcol := shadow_of(fc(c, st)).darkened(0.25)
	for i in folds:
		var u := 0.3 + 0.45 * (float(i) + 0.5) / folds
		var side := 1.0 if (i + seed) % 2 == 0 else -1.0
		var r := lerpf(ra, rb, u)
		var p0 := a + d * length * u + nf * side * r * 0.92
		var p1 := p0 - nf * side * r * 0.8 + d * minf(length * 0.12, 9.0)
		var pm := p0.lerp(p1, 0.5) - d * 2.0
		cv.draw_polyline(PackedVector2Array([p0, pm, p1]), fcol, 1.5, true)


## A ribbon (sash end, bandana tail, coat tail) hanging from root. It sways with
## time and blows back when the fighter moves. down_ang uses the dir() convention.
func flutter(cv: CanvasItem, root: Vector2, down_ang: float, length: float, w0: float, w1: float, c: Color, st: Dictionary, phase := 0.0, segs := 5) -> void:
	var tt: float = st.get("time", 0.0)
	var vx: float = clampf(st.get("vx", 0.0), -14.0, 14.0)
	var vy: float = clampf(st.get("vy", 0.0), -20.0, 20.0)
	var centers := [root]
	var ang := down_ang
	var p := root
	for i in segs:
		var u := float(i + 1) / segs
		ang += (-vx * 1.6 + vy * 0.8 + sin(tt * 6.5 + phase + u * 2.6) * 6.0) * u
		ang = clampf(ang, down_ang - 110.0, down_ang + 60.0)
		p += dir(ang) * length / segs
		centers.append(p)
	var left := PackedVector2Array()
	var right := PackedVector2Array()
	for i in centers.size():
		var a: Vector2 = centers[maxi(i - 1, 0)]
		var b: Vector2 = centers[mini(i + 1, centers.size() - 1)]
		var t := (b - a).normalized()
		var nrm := Vector2(-t.y, t.x)
		var w := lerpf(w0, w1, float(i) / segs)
		left.append(centers[i] + nrm * w)
		right.append(centers[i] - nrm * w)
	right.reverse()
	shape(cv, left + right, c, st, true, 2.0)


## Long coat tails: the back panel (call from draw_back_fx) hangs behind the
## legs, the front flap (call from draw_leg_extra for "f") over the near leg.
func coat_tail(cv: CanvasItem, J: Dictionary, st: Dictionary, c: Color, front: bool, length := 100.0, w := 20.0) -> void:
	var side := Vector2(1, 0).rotated(J.torso_ang)
	var up := Vector2(0, -1).rotated(J.torso_ang)
	var ch: float = dims.chest
	if front:
		flutter(cv, J.hip + side * 12.0 * ch + up * 18.0, 2.0, length + 10.0, w * 0.42, w * 0.3, c, st, 1.3, 5)
	else:
		var root: Vector2 = J.hip - side * 12.0 * ch + up * 30.0
		flutter(cv, root, -12.0, length + 30.0, w, w * 0.8, c, st, 0.2, 5)


## Open coat over the torso: a back panel and a lapel, like an open jacket.
func coat_torso(cv: CanvasItem, st: Dictionary, L: float, ch: float, c: Color, lining := Color(0, 0, 0, 0)) -> void:
	var back := PackedVector2Array([Vector2(-15 * ch, 8), Vector2(-2 * ch, 8), Vector2(2 * ch, -L * 0.5), Vector2(4 * ch, -L * 0.94), Vector2(-2 * ch, -L - 3), Vector2(-14 * ch, -L - 1), Vector2(-21 * ch, -L * 0.64), Vector2(-16.5 * ch, -L * 0.36)])
	shape(cv, back, c, st)
	var lap := PackedVector2Array([Vector2(13 * ch, 8), Vector2(16.5 * ch, 8), Vector2(15 * ch, -L * 0.2), Vector2(14.5 * ch, -L * 0.38), Vector2(19 * ch, -L * 0.6), Vector2(20 * ch, -L * 0.75), Vector2(17.5 * ch, -L * 0.92), Vector2(13 * ch, -L - 3), Vector2(9 * ch, -L * 0.8), Vector2(13 * ch, -L * 0.5)])
	shape(cv, lap, c, st)
	if lining.a > 0.0:
		cv.draw_polyline(PackedVector2Array([Vector2(13 * ch, 8), Vector2(13 * ch, -L * 0.5), Vector2(9 * ch, -L * 0.8), Vector2(13 * ch, -L - 3)]), fc(lining, st), 3.0, true)


# ---------------------------------------------------------------- renderer

## st: {flash, tint, time, far, rage, vx, vy}
func draw(cv: CanvasItem, J: Dictionary, p: Dictionary, st: Dictionary) -> void:
	_rot = 0.0
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


func hand_kind(p: Dictionary, s: String) -> String:
	if p.has("hand_" + s):
		return String(p["hand_" + s])
	if has_swords:
		return "fist"
	if String(p.get("face", "")) in ["hurt", "ko"]:
		return "open"
	return "fist"


func draw_arm(cv: CanvasItem, J: Dictionary, p: Dictionary, s: String, st: Dictionary) -> void:
	var sh: Vector2 = J.shoulder + Vector2(3.0 if s == "f" else -3.0, 2.0).rotated(J.torso_ang)
	var el: Vector2 = J["elbow_" + s]
	var ha: Vector2 = J["hand_" + s]
	if has_swords and s == "b":
		draw_sword(cv, J, p, s, st)
	var k: float = dims.limb
	var sleeve: Color = col.get("sleeve", col.top)
	var sl := String(style.sleeves)
	# upper arm
	if sl == "long":
		cloth(cv, sh, el, 12.5 * k, 11.0 * k, sleeve, st, 1.05, 1, 0)
	else:
		shape(cv, muscle(sh, el, 11.0 * k, 9.0 * k, Vector2(0.48, 0.17), Vector2(0.32, 0.13)), col.skin, st)
		if sl == "short":
			cloth(cv, sh, sh.lerp(el, 0.58), 13.0 * k, 12.0 * k, sleeve, st, 1.14, 1, 1)
		elif not style.get("slim", false):
			# deltoid cap
			var dd := (el - sh).normalized()
			shape(cv, ellipse(sh + dd * 7.0 * k, 13.5 * k, 10.5 * k, 14, dd.angle()), col.skin, st)
	# forearm
	if sl == "long":
		cloth(cv, el, ha, 11.0 * k, 9.5 * k, sleeve, st, 1.12, 1, 1)
	else:
		shape(cv, muscle(el, ha, 9.8 * k, 7.0 * k, Vector2(0.22, 0.12), Vector2(0.2, 0.24)), col.skin, st)
	draw_arm_extra(cv, J, p, s, st)
	draw_hand(cv, el, ha, hand_kind(p, s), col.get("glove", col.skin), st)
	if has_swords and s == "f":
		draw_sword(cv, J, p, s, st)


## Hands: "fist" (also used to grip swords) or "open".
func draw_hand(cv: CanvasItem, el: Vector2, ha: Vector2, kind: String, c: Color, st: Dictionary) -> void:
	var u := (ha - el).normalized()
	if u == Vector2.ZERO:
		u = Vector2.DOWN
	var v := Vector2(u.y, -u.x)
	var k: float = dims.limb
	var o := ha - u * 3.0 * k
	var line := shadow_of(fc(c, st)).darkened(0.3)
	if kind == "open":
		for y in [-5.4, -1.8, 1.8, 5.4]:
			var a := local_pts(o, u, v, k, [[9.0, y]])[0]
			var b := local_pts(o, u, v, k, [[19.0 - absf(y) * 0.5, y * 1.15]])[0]
			shape(cv, capsule(a, b, 2.3 * k, 1.8 * k, 4), c, st, false, 1.6)
		shape(cv, local_pts(o, u, v, k, [[-1, -7], [7, -8], [11, -6.5], [11, 6.5], [7, 8], [-1, 7]]), c, st, true, 2.0)
		var ta := local_pts(o, u, v, k, [[3.0, 6.0]])[0]
		var tb := local_pts(o, u, v, k, [[11.0, 11.5]])[0]
		shape(cv, capsule(ta, tb, 3.0 * k, 2.2 * k, 4), c, st, false, 1.6)
		return
	var fist := local_pts(o, u, v, k, [[-2, -7.5], [5, -9], [12, -8.6], [16, -5.5], [17, 0], [16, 5.5], [12, 8.6], [4, 9], [-2, 7.5]])
	shape(cv, fist, c, st, true, 2.2)
	for y in [-4.6, -0.6, 3.4]:
		var a := local_pts(o, u, v, k, [[9.5, y], [15.5, y + 0.3]])
		cv.draw_line(a[0], a[1], line, 1.3, true)
	var t0 := local_pts(o, u, v, k, [[2.5, 6.0]])[0]
	var t1 := local_pts(o, u, v, k, [[11.0, 3.5]])[0]
	shape(cv, capsule(t0, t1, 3.4 * k, 2.8 * k, 4), c, st, false, 1.6)


func draw_leg(cv: CanvasItem, J: Dictionary, p: Dictionary, s: String, st: Dictionary) -> void:
	var hip: Vector2 = J.hip + Vector2(5.0 if s == "f" else -5.0, 0).rotated(J.torso_ang)
	var kn: Vector2 = J["knee_" + s]
	var ft: Vector2 = J["foot_" + s]
	var toe: Vector2 = J["toe_" + s]
	var k: float = dims.limb
	var pants: Color = col.pants
	var seed := 0 if s == "f" else 1
	# foot first so the shin overlaps it
	draw_foot(cv, kn, ft, toe, st)
	if style.pants == "long":
		cloth(cv, kn, ft, 12.5 * k, 10.0 * k, pants, st, 1.22, 2, seed)
	else:
		shape(cv, muscle(kn, ft, 11.0 * k, 7.6 * k, Vector2(0.3, 0.05), Vector2(0.3, 0.34)), col.skin, st)
	if style.feet == "boot":
		var top := kn.lerp(ft, 0.4)
		shape(cv, muscle(top, ft, 11.5 * k, 10.0 * k, Vector2(0.5, 0.04), Vector2(0.3, 0.08), 4), col.shoes, st)
		var d := (ft - top).normalized()
		var nf := Vector2(d.y, -d.x)
		cv.draw_line(top + nf * 11.0 * k + d * 4.0, top - nf * 11.0 * k + d * 4.0, fc(col.shoes, st).lightened(0.25), 2.0, true)
	match String(style.pants):
		"knee":
			cloth(cv, hip, kn.lerp(ft, 0.25), 17.0 * k, 14.5 * k, pants, st, 1.12, 2, seed)
		"short":
			cloth(cv, hip, kn, 16.5 * k, 15.0 * k, pants, st, 1.1, 2, seed)
		_:
			cloth(cv, hip, kn, 16.0 * k, 12.5 * k, pants, st, 1.0, 2, seed)
	if style.get("cuff", false):
		var c_end := kn
		if style.pants == "knee":
			c_end = kn.lerp(ft, 0.25)
		var d := (c_end - hip).normalized()
		var n: Vector2 = Vector2(-d.y, d.x) * 16.5 * k * 1.1
		var band := PackedVector2Array([c_end - d * 7.0 + n, c_end + d * 4.0 + n * 1.08, c_end + d * 4.0 - n * 1.08, c_end - d * 7.0 - n])
		shape(cv, band, col.get("cuff_c", Color.WHITE), st, true, 2.0)
	draw_leg_extra(cv, J, p, s, st)


func draw_foot(cv: CanvasItem, kn: Vector2, ft: Vector2, toe: Vector2, st: Dictionary) -> void:
	var u := (toe - ft).normalized()
	if u == Vector2.ZERO:
		u = Vector2.RIGHT
	var v := Vector2(-u.y, u.x)
	if v.dot(ft - kn) < 0.0:
		v = -v
	var k: float = dims.limb
	var F: float = ft.distance_to(toe) / k
	match String(style.feet):
		"sandal":
			shape(cv, local_pts(ft, u, v, k, [[-9, 5.5], [F + 8, 5.0], [F + 8, 9.5], [-9, 9.5]]), col.shoes, st, false, 1.8)
			shape(cv, local_pts(ft, u, v, k, [[-7, -4], [-8.5, 2], [-6, 6], [4, 6.5], [F * 0.7, 6], [F + 4, 5.5], [F + 7, 2.5], [F + 5.5, -1.5], [F * 0.6, -3.5], [6, -7], [-2, -8]]), col.skin, st, true, 2.0)
			var line := shadow_of(fc(col.skin, st)).darkened(0.2)
			for i in 2:
				var a := local_pts(ft, u, v, k, [[F + 1.0 + i * 2.5, -1.0 + i * 1.5], [F + 2.5 + i * 2.5, 4.5]])
				cv.draw_line(a[0], a[1], line, 1.2, true)
			var strap := local_pts(ft, u, v, k, [[2, -6.5], [F * 0.55, 5.5]])
			cv.draw_line(strap[0], strap[1], fc(col.shoes, st).darkened(0.1), 3.0, true)
		"shoe":
			shape(cv, local_pts(ft, u, v, k, [[-9, -5], [-10, 3], [-8, 8], [F + 6, 8], [F + 11, 5], [F + 11, 2], [F + 4, -2.5], [F * 0.5, -5.5], [5, -8.5], [-3, -9]]), col.shoes, st, true, 2.2)
			var sole := local_pts(ft, u, v, k, [[-9, 6], [F + 9, 6]])
			cv.draw_line(sole[0], sole[1], fc(col.shoes, st).lightened(0.3), 1.5, true)
		_:
			shape(cv, local_pts(ft, u, v, k, [[-9, -6], [-10, 3], [-8, 8.5], [F + 6, 8.5], [F + 10, 5], [F + 9, 0], [F + 3, -3.5], [F * 0.5, -6.5], [5, -9.5], [-3, -10]]), col.shoes, st, true, 2.2)
			var sole := local_pts(ft, u, v, k, [[-9, 5.5], [F + 9, 5.5]])
			cv.draw_line(sole[0], sole[1], fc(col.shoes, st).darkened(0.45), 2.4, true)


func torso_pts(L: float, ch: float) -> PackedVector2Array:
	return PackedVector2Array([
		Vector2(-15 * ch, 8), Vector2(16 * ch, 8),
		Vector2(15 * ch, -L * 0.2), Vector2(14.5 * ch, -L * 0.38),
		Vector2(19 * ch, -L * 0.6), Vector2(20 * ch, -L * 0.75), Vector2(17.5 * ch, -L * 0.92), Vector2(13 * ch, -L - 2.5),
		Vector2(-12 * ch, -L - 1), Vector2(-19 * ch, -L * 0.88), Vector2(-21 * ch, -L * 0.64), Vector2(-16.5 * ch, -L * 0.36),
		Vector2(-15 * ch, -L * 0.12),
	])


func draw_torso(cv: CanvasItem, J: Dictionary, p: Dictionary, st: Dictionary) -> void:
	var L: float = dims.torso
	var ch: float = dims.chest
	xf(cv, J.hip, J.torso_ang)
	var pts := torso_pts(L, ch)
	var base: Color = col.skin
	if style.top in ["shirt", "suit"]:
		base = col.top
	shape(cv, pts, base, st, true, 2.6)
	if style.top in ["none", "vest", "coat"]:
		draw_anatomy(cv, L, ch, st)
	elif style.top == "shirt":
		var fold := shadow_of(fc(base, st)).darkened(0.1)
		cv.draw_polyline(PackedVector2Array([Vector2(16 * ch, -L * 0.55), Vector2(8 * ch, -L * 0.45), Vector2(2 * ch, -L * 0.42)]), fold, 1.5, true)
		cv.draw_polyline(PackedVector2Array([Vector2(-17 * ch, -L * 0.72), Vector2(-8 * ch, -L * 0.6)]), fold, 1.5, true)
	draw_torso_extra(cv, J, p, st, L, ch)
	if col.sash.a > 0.0:
		var sash := PackedVector2Array([Vector2(-17 * ch, 9), Vector2(18 * ch, 9), Vector2(16 * ch, -L * 0.22), Vector2(-17 * ch, -L * 0.2)])
		shape(cv, sash, col.sash, st)
		var fold := shadow_of(fc(col.sash, st))
		cv.draw_line(Vector2(-15 * ch, -L * 0.08), Vector2(14 * ch, -L * 0.12), fold, 1.5, true)
		if style.get("sash_tail", true):
			flutter(cv, Vector2(-14 * ch, -L * 0.06), -14.0, 34.0, 6.0, 4.0, col.sash, st, 0.0, 4)
			flutter(cv, Vector2(-12 * ch, -L * 0.04), 6.0, 26.0, 5.5, 3.5, col.sash, st, 1.7, 4)
	xf_reset(cv)


## Pecs, abs and collarbones for bare or open-shirt torsos.
func draw_anatomy(cv: CanvasItem, L: float, ch: float, st: Dictionary) -> void:
	var skin := fc(col.skin, st)
	var sh := shadow_of(skin)
	var line := sh.darkened(0.24)
	# shadow under the pecs
	var pec := PackedVector2Array()
	for i in 9:
		var u := float(i) / 8.0
		pec.append(Vector2(lerpf(2.5, 19.5, u) * ch, -L * (0.6 - 0.075 * sin(u * PI)) - L * 0.04 * u))
	var under := pec.duplicate()
	for i in range(8, -1, -1):
		under.append(pec[i] + Vector2(0, 5.5 + 2.5 * sin(float(i) / 8.0 * PI)))
	if not Geometry2D.triangulate_polygon(under).is_empty():
		cv.draw_colored_polygon(under, Color(sh, 0.82))
	# upper pec highlight
	var pec_hi := PackedVector2Array([
		Vector2(5.0 * ch, -L * 0.82), Vector2(15.5 * ch, -L * 0.8),
		Vector2(16.5 * ch, -L * 0.67), Vector2(5.5 * ch, -L * 0.66),
	])
	cv.draw_colored_polygon(pec_hi, Color(skin.lightened(0.14), 0.55))
	cv.draw_polyline(pec, line, 1.85, true)
	# sternum cleavage
	cv.draw_line(Vector2(3.5 * ch, -L * 0.9), Vector2(3.5 * ch, -L * 0.58), Color(line, 0.8), 1.6, true)
	# collarbone
	cv.draw_polyline(PackedVector2Array([Vector2(4.5 * ch, -L * 0.93), Vector2(11 * ch, -L * 0.9), Vector2(17.5 * ch, -L * 0.92)]), Color(line, 0.85), 1.5, true)
	# abs shading & lines
	cv.draw_line(Vector2(7 * ch, -L * 0.54), Vector2(8 * ch, -L * 0.14), Color(line, 0.85), 1.6, true)
	for i in 3:
		var y := -L * (0.46 - i * 0.11)
		cv.draw_colored_polygon(PackedVector2Array([
			Vector2(3.2 * ch, y), Vector2(13.2 * ch, y + 1.0),
			Vector2(12.8 * ch, y + 4.0), Vector2(3.5 * ch, y + 3.0),
		]), Color(sh, 0.48))
		cv.draw_polyline(PackedVector2Array([Vector2(3 * ch, y + 1.0), Vector2(7.5 * ch, y), Vector2(13 * ch, y + 1.5)]), Color(line, 0.78), 1.4, true)
	# obliques & serratus ribs
	cv.draw_line(Vector2(14 * ch, -L * 0.38), Vector2(11 * ch, -L * 0.06), Color(line, 0.75), 1.5, true)
	for i in 2:
		var ry := -L * (0.5 - i * 0.07)
		cv.draw_line(Vector2(14.5 * ch, ry), Vector2(17.5 * ch, ry + 3.0), Color(line, 0.65), 1.2, true)


func draw_head_all(cv: CanvasItem, J: Dictionary, p: Dictionary, st: Dictionary) -> void:
	var R: float = dims.head
	var nd: Vector2 = (J.neck - J.head).normalized()
	limb(cv, J.neck + nd * 6.0, J.head + nd * R * 0.5, 9.0, 8.5, col.skin, st)
	# jaw shadow on the neck
	cv.draw_colored_polygon(ellipse(J.head + nd * R * 0.82 + Vector2(nd.y, -nd.x) * 2.0, 7.0, 6.0, 10), shadow_of(fc(col.skin, st)))
	draw_neck_extra(cv, J, p, st)
	xf(cv, J.head, J.head_ang)
	draw_hair_back(cv, R, p, st)
	draw_face(cv, R, p, st)
	draw_hair(cv, R, p, st)
	draw_brows(cv, R, p, st)
	draw_hat(cv, R, p, st)
	xf_reset(cv)
	draw_head_extra(cv, J, p, st)


func head_pts(R: float) -> PackedVector2Array:
	var pts := PackedVector2Array()
	for i in 36:
		var a := TAU * float(i) / 36.0
		var chin := pow(maxf(0.0, cos(a - deg_to_rad(66.0))), 8.5)
		var jaw := pow(maxf(0.0, cos(a - deg_to_rad(92.0))), 3.8)
		var cheek := pow(maxf(0.0, cos(a - deg_to_rad(28.0))), 6.0)
		var r := R * (1.0 + 0.36 * chin + 0.09 * jaw + 0.04 * cheek)
		pts.append(Vector2(cos(a) * r * 0.95, sin(a) * r * 1.02))
	return pts


## Faces are drawn in a three-quarter view turned toward the opponent:
## the near eye is full size and the far eye is narrower near the cheek line.
const EYE_NEAR := Vector2(0.14, 0.1)
const EYE_FAR := Vector2(0.7, 0.08)
const MOUTH := Vector2(0.48, 0.64)
var _squash := 1.0


func draw_face(cv: CanvasItem, R: float, p: Dictionary, st: Dictionary) -> void:
	var face: String = p.get("face", "normal")
	var skin := fc(col.skin, st)
	# ear
	shape(cv, ellipse(Vector2(-R * 0.48, R * 0.12), R * 0.19, R * 0.27, 12), col.skin, st, false)
	var head := head_pts(R)
	shape(cv, head, col.skin, st, true, 2.7, 0.42)
	# anime inner ear fold
	cv.draw_arc(Vector2(-R * 0.48, R * 0.12), R * 0.1, -1.0, 2.0, 6, shadow_of(skin).darkened(0.28), 1.6, true)
	cv.draw_line(Vector2(-R * 0.52, R * 0.12), Vector2(-R * 0.43, R * 0.18), shadow_of(skin).darkened(0.25), 1.3, true)
	# cheekbone / jaw rim highlight
	cv.draw_polyline(PackedVector2Array([
		Vector2(R * 0.68, R * 0.18), Vector2(R * 0.72, R * 0.42), Vector2(R * 0.48, R * 0.88)
	]), Color(skin.lightened(0.18), 0.65), 1.6, true)
	var ink := OUTLINE
	for far in [true, false]:
		_squash = 0.62 if far else 1.0
		var eye: Vector2 = (EYE_FAR if far else EYE_NEAR) * R
		match face:
			"hurt":
				var k := _squash
				cv.draw_polyline(PackedVector2Array([eye + Vector2(-R * 0.14 * k, -R * 0.14), eye + Vector2(R * 0.1 * k, 0), eye + Vector2(-R * 0.14 * k, R * 0.14)]), ink, 3.0, true)
			"ko":
				var k := _squash
				cv.draw_line(eye + Vector2(-R * 0.12 * k, -R * 0.12), eye + Vector2(R * 0.12 * k, R * 0.12), ink, 2.8, true)
				cv.draw_line(eye + Vector2(-R * 0.12 * k, R * 0.12), eye + Vector2(R * 0.12 * k, -R * 0.12), ink, 2.8, true)
			"closed":
				cv.draw_arc(eye + Vector2(0, -R * 0.05), R * 0.15 * _squash, 0.3, PI - 0.3, 7, ink, 2.6, true)
			_:
				draw_eye(cv, eye, R, face, st)
	_squash = 1.0
	# nose: crisp anime wedge with shadow plane and bridge line
	var nz := Vector2(R * 0.5, R * 0.2)
	cv.draw_colored_polygon(PackedVector2Array([nz, nz + Vector2(R * 0.12, R * 0.22), nz + Vector2(-R * 0.05, R * 0.24)]), shadow_of(skin).darkened(0.06))
	cv.draw_polyline(PackedVector2Array([nz + Vector2(R * 0.02, R * 0.02), nz + Vector2(R * 0.12, R * 0.22), nz + Vector2(R * 0.02, R * 0.24)]), shadow_of(skin).darkened(0.42), 1.8, true)
	draw_mouth(cv, R, face, st)
	draw_face_extra(cv, R, p, st)


## Brows go over the fringe, as in anime art.
func draw_brows(cv: CanvasItem, R: float, p: Dictionary, st: Dictionary) -> void:
	var face: String = p.get("face", "normal")
	var tilt := 0.0
	if face in ["angry", "shout", "attack"]:
		tilt = R * 0.16
	elif face == "hurt":
		tilt = -R * 0.12
	for far in [true, false]:
		_squash = 0.62 if far else 1.0
		draw_brow(cv, (EYE_FAR if far else EYE_NEAR) * R, R, tilt, st)
	_squash = 1.0


func draw_mouth(cv: CanvasItem, R: float, face: String, _st: Dictionary) -> void:
	var m := MOUTH * R
	var ink := OUTLINE
	match face:
		"shout":
			var o := local_pts(m, Vector2.RIGHT, Vector2.DOWN, R, [[-0.24, -0.12], [0.2, -0.14], [0.17, 0.08], [0.06, 0.26], [-0.16, 0.2]])
			cv.draw_colored_polygon(o, Color("5a1018"))
			cv.draw_colored_polygon(local_pts(m, Vector2.RIGHT, Vector2.DOWN, R, [[-0.1, 0.24], [0.06, 0.14], [0.08, 0.24]]), Color("d0545a"))
			cv.draw_colored_polygon(local_pts(m, Vector2.RIGHT, Vector2.DOWN, R, [[-0.22, -0.11], [0.19, -0.13], [0.18, -0.06], [-0.2, -0.04]]), Color.WHITE)
			outline(cv, o, 2.0)
		"attack", "hurt":
			var g := local_pts(m, Vector2.RIGHT, Vector2.DOWN, R, [[-0.24, -0.08], [0.18, -0.11], [0.16, 0.1], [-0.2, 0.1]])
			cv.draw_colored_polygon(g, Color.WHITE)
			cv.draw_line(g[0].lerp(g[3], 0.5), g[1].lerp(g[2], 0.5), Color(0.55, 0.5, 0.5), 1.2, true)
			for i in 3:
				var x := lerpf(-0.12, 0.1, float(i) / 2.0)
				var a := local_pts(m, Vector2.RIGHT, Vector2.DOWN, R, [[x, -0.1], [x, 0.1]])
				cv.draw_line(a[0], a[1], Color(0.55, 0.5, 0.5), 1.0, true)
			outline(cv, g, 2.0)
		"grin":
			var g := PackedVector2Array()
			for i in 9:
				var a := lerpf(0.0, PI, float(i) / 8.0)
				g.append(m + Vector2(-cos(a) * R * 0.32, sin(a) * R * 0.24 - R * 0.1))
			cv.draw_colored_polygon(g, Color("5a1018"))
			var teeth := PackedVector2Array([g[0], g[8], g[8] + Vector2(-R * 0.02, R * 0.08), g[0] + Vector2(R * 0.02, R * 0.08)])
			cv.draw_colored_polygon(teeth, Color.WHITE)
			outline(cv, g, 2.0)
			cv.draw_arc(g[0] + Vector2(-R * 0.05, -R * 0.02), R * 0.08, PI - 0.9, PI + 0.6, 5, ink, 1.6, true)
		"ko":
			cv.draw_arc(m + Vector2(0, R * 0.14), R * 0.15, PI + 0.4, TAU - 0.4, 6, ink, 2.0, true)
		"angry":
			cv.draw_polyline(PackedVector2Array([m + Vector2(-R * 0.18, R * 0.03), m + Vector2(0, -R * 0.02), m + Vector2(R * 0.16, R * 0.02)]), ink, 2.2, true)
		_:
			cv.draw_polyline(PackedVector2Array([m + Vector2(-R * 0.17, -R * 0.01), m + Vector2(0, R * 0.02), m + Vector2(R * 0.15, -R * 0.02)]), ink, 2.0, true)


func draw_eye(cv: CanvasItem, eye: Vector2, R: float, face: String, st: Dictionary) -> void:
	var w := R * 0.24 * _squash
	var h := R * 0.35
	var lid := 0.0
	if face in ["angry", "shout", "attack"]:
		lid = 0.4
	var sc := PackedVector2Array()
	for i in 16:
		var a := TAU * float(i) / 16.0
		var y := sin(a) * h
		if y < 0.0:
			y *= 1.0 - lid * (0.6 + 0.4 * cos(a))
		else:
			y *= 0.8
		sc.append(eye + Vector2(cos(a) * w, y))
	cv.draw_colored_polygon(sc, fc(Color(0.98, 0.97, 0.95), st))
	var ic := eye + Vector2(w * 0.28, h * 0.08)
	var iris := ellipse(ic, w * 0.68, h * 0.66, 14)
	var ir := Geometry2D.intersect_polygons(iris, sc)
	_fill(cv, ir, fc(col.eye, st))
	if not ir.is_empty():
		_fill(cv, Geometry2D.intersect_polygons(ellipse(ic + Vector2(0, h * 0.3), w * 0.55, h * 0.4, 12), ir[0]), fc(col.eye, st).lightened(0.4))
	_fill(cv, Geometry2D.intersect_polygons(ellipse(ic + Vector2(w * 0.05, h * 0.02), w * 0.32, h * 0.34, 10), sc), Color(0.04, 0.03, 0.05))
	cv.draw_circle(ic + Vector2(w * 0.25, -h * 0.28 + lid * h * 0.5), R * 0.065 * sqrt(_squash), Color.WHITE)
	cv.draw_circle(ic + Vector2(-w * 0.25, h * 0.32), R * 0.03, Color(1, 1, 1, 0.85))
	# upper lash: thick, with a flick at the outer (back) corner
	var lash := PackedVector2Array()
	for i in range(8, 17):
		lash.append(sc[i % 16])
	lash.append(sc[8] + Vector2(-w * 0.45, -h * 0.28))
	lash.reverse()
	cv.draw_polyline(lash, OUTLINE, 3.6, true)
	cv.draw_line(sc[5], sc[7], Color(OUTLINE, 0.7), 1.4, true)


func draw_brow(cv: CanvasItem, eye: Vector2, R: float, tilt: float, st: Dictionary) -> void:
	var k := _squash
	var inner := eye + Vector2(R * 0.24 * k, -R * 0.4 + tilt)
	var outer := eye + Vector2(-R * 0.24 * k, -R * 0.46 - tilt * 0.35)
	var d := (inner - outer).normalized()
	var n := Vector2(-d.y, d.x)
	var c := fc(col.hair, st).darkened(0.2)
	var pts := PackedVector2Array([outer + n * 1.2, outer.lerp(inner, 0.5) - n * 3.0, inner - n * 2.4, inner + n * 1.6, outer.lerp(inner, 0.5) + n * 1.8])
	if not Geometry2D.triangulate_polygon(pts).is_empty():
		cv.draw_colored_polygon(pts, c)


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


## Spiky hair helper: curved clumps of hair along an arc of the skull.
## sweep leans the tips (degrees), so the hair looks combed back or windblown.
func spikes(cv: CanvasItem, R: float, from_deg: float, to_deg: float, n: int, length: float, c: Color, st: Dictionary, jag := 0.35, center := Vector2.ZERO, seed := 1, sweep := -12.0) -> void:
	var pts := PackedVector2Array()
	var rng := RandomNumberGenerator.new()
	rng.seed = seed
	pts.append(center)
	var tips := []
	for i in n:
		var a0 := deg_to_rad(lerpf(from_deg, to_deg, float(i) / n))
		var a1 := deg_to_rad(lerpf(from_deg, to_deg, float(i + 1) / n))
		var am := (a0 + a1) * 0.5 + deg_to_rad(sweep + rng.randf_range(-6.0, 6.0))
		var ln := R + length * (1.0 + rng.randf_range(-jag, jag))
		var b0 := center + Vector2(cos(a0), sin(a0)) * R * 1.02
		var b1 := center + Vector2(cos(a1), sin(a1)) * R * 1.02
		var tip := center + Vector2(cos(am), sin(am)) * ln
		var tang := Vector2(-sin(am), cos(am)) * (-signf(sweep) * length * 0.16)
		var c0 := b0.lerp(tip, 0.5) + tang
		var c1 := tip.lerp(b1, 0.5) + tang
		if i == 0:
			pts.append(b0)
		for k in range(1, 4):
			var u := float(k) / 4.0
			pts.append(b0.lerp(c0, u).lerp(c0.lerp(tip, u), u))
		pts.append(tip)
		for k in range(1, 4):
			var u := float(k) / 4.0
			pts.append(tip.lerp(c1, u).lerp(c1.lerp(b1, u), u))
		pts.append(b1)
		tips.append([b0.lerp(b1, 0.5), tip])
	shape(cv, pts, c, st, true, 2.2)
	var strand := shadow_of(fc(c, st)).darkened(0.25)
	for t in tips:
		var a: Vector2 = t[0]
		var b: Vector2 = t[1]
		cv.draw_line(a.lerp(b, 0.15), a.lerp(b, 0.7), strand, 1.3, true)


## Called every frame while fighting so a character can emit particles (steam, flames).
func update_fx(_f, _fx) -> void:
	pass


## Whole-body color tint for the current pose (e.g. Gear Second pink).
func tint_for(_p: Dictionary) -> Color:
	return Color(0, 0, 0, 0)
