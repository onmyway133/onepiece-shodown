extends Node
## Global match settings and helpers shared by every screen.

const ROSTER := ["luffy", "zoro"]
const STAGES := [
	{"id": "merry", "name": "Going Merry - Sunset"},
	{"id": "wano", "name": "Wano - Sakura Shrine"},
	{"id": "alabasta", "name": "Alabasta - Desert Night"},
]
const DIFFICULTIES := ["EASY", "NORMAL", "HARD", "PIRATE KING"]

var mode := "cpu"  # cpu, versus, training, demo
var p1_char := "luffy"
var p2_char := "zoro"
var stage := "merry"
var difficulty := 1
var rounds_to_win := 2
var round_time := 60

var _chars := {}
var _font_cache := {}


func char_data(id: String) -> CharData:
	if not _chars.has(id):
		var script: GDScript = load("res://scripts/chars/%s.gd" % id)
		_chars[id] = script.new()
	return _chars[id]


## Bold display font: uses fonts installed on the machine (Impact on macOS)
## and falls back to Godot's built-in font elsewhere.
func font(kind := "display") -> Font:
	if _font_cache.has(kind):
		return _font_cache[kind]
	var f := SystemFont.new()
	match kind:
		"title":
			f.font_names = PackedStringArray(["Hiragino Mincho ProN", "Impact", "Arial Black", "DejaVu Sans"])
			f.font_weight = 800
		"body":
			f.font_names = PackedStringArray(["Avenir Next", "Helvetica Neue", "Arial", "DejaVu Sans"])
			f.font_weight = 700
		_:
			f.font_names = PackedStringArray(["Impact", "Arial Black", "Haettenschweiler", "DejaVu Sans"])
			f.font_weight = 900
	f.antialiasing = TextServer.FONT_ANTIALIASING_GRAY
	_font_cache[kind] = f
	return f


func stage_name(id: String) -> String:
	for s in STAGES:
		if s.id == id:
			return s.name
	return id
