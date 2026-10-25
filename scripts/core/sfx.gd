extends Node
## Sound effects and music. Sounds live in res://assets/sfx/<name>.wav,
## music in res://assets/music/<name>.ogg.

const VOICES := 16

var _players: Array[AudioStreamPlayer] = []
var _next := 0
var _cache := {}
var _music: AudioStreamPlayer
var _music_name := ""
var sfx_volume := 0.0
var music_volume := -6.0


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	for i in VOICES:
		var p := AudioStreamPlayer.new()
		add_child(p)
		_players.append(p)
	_music = AudioStreamPlayer.new()
	_music.volume_db = music_volume
	add_child(_music)


func _stream(path: String) -> AudioStream:
	if _cache.has(path):
		return _cache[path]
	var s: AudioStream = null
	if ResourceLoader.exists(path):
		s = load(path)
	_cache[path] = s
	return s


## Plays a one-shot effect. pitch_var randomizes pitch a little so repeats feel alive.
func play(name: String, volume := 0.0, pitch := 1.0, pitch_var := 0.06) -> void:
	var s := _stream("res://assets/sfx/%s.wav" % name)
	if s == null:
		return
	var p := _players[_next]
	_next = (_next + 1) % VOICES
	p.stream = s
	p.volume_db = sfx_volume + volume
	p.pitch_scale = pitch * randf_range(1.0 - pitch_var, 1.0 + pitch_var)
	p.play()


func music(name: String) -> void:
	if name == _music_name and _music.playing:
		return
	_music_name = name
	var s := _stream("res://assets/music/%s.ogg" % name)
	if s == null:
		_music.stop()
		return
	if s is AudioStreamOggVorbis:
		(s as AudioStreamOggVorbis).loop = true
	_music.stream = s
	_music.volume_db = music_volume
	_music.play()


func stop_music() -> void:
	_music_name = ""
	_music.stop()
