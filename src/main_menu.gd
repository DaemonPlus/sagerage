extends Control

func _ready() -> void:
	$HBoxContainer/StartButton.grab_focus()
	$HBoxContainer/StartButton.pressed.connect(SoundHandler.select.play)
	SoundHandler.titlemusic.play()


func _on_start_button_pressed() -> void:
	if OS.has_feature("ngio"):
		JavaScriptBridge.eval("initSession();")
	get_tree().change_scene_to_file("res://src/game.tscn")


func _on_fullscreen_button_pressed() -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	elif DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


func _on_tree_exiting() -> void:
	SoundHandler.fade_out_music(SoundHandler.titlemusic)
