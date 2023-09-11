extends Node

@onready var select = $SFX/Select

@onready var titlemusic = $Music/Title
@onready var gamemusic = $Music/GameMusic

var cur_music: AudioStreamPlayer = null

func stop_all_music() -> void:
	for m in $Music.get_children():
		m.stop()
	cur_music = null


func enable_slow_music(i: bool):
	var tween = get_tree().create_tween()
	if i:
		tween.tween_property(gamemusic, "pitch_scale", 0.5, 1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	else:
		tween.tween_property(gamemusic, "pitch_scale", 1, 1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	AudioServer.set_bus_effect_enabled(1, 0, i)


func fade_out_music(stream: AudioStreamPlayer):
	var tween = get_tree().create_tween()
	tween.tween_property(stream, "volume_db", -80, 0.25).from(0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_callback(stream.stop)


func fade_in_music(stream: AudioStreamPlayer):
	stream.play()
	var tween = get_tree().create_tween()
	tween.tween_property(stream, "volume_db", 0, 0.25).from(-80).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	cur_music = stream
