extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer/Mailboxes/Label2.text = str(Global.results_data.score)
	$VBoxContainer/Dollas/Label2.text = "$" + str(Global.results_data.total_bills_collected * 5)
	$VBoxContainer/Cars/Label2.text = str(Global.results_data.cars_destroyed)
	$VBoxContainer/Purchases/Label2.text = str(Global.results_data.lefties_purchased)
	$VBoxContainer/Attacks/Label2.text = str(Global.results_data.lefty_attacks)
	if OS.has_feature("ngio"):
		if Global.results_data.score != 0:
			JavaScriptBridge.eval("postScore('Mailboxes Hit', %s);" % Global.results_data.score)
		if Global.results_data.total_bills_collected != 0:
			JavaScriptBridge.eval("postScore('Dollas Collected', %s);" % (Global.results_data.total_bills_collected * 500))
		if Global.results_data.cars_destroyed != 0:
			JavaScriptBridge.eval("postScore('Cars Destroyed', %s);" % Global.results_data.cars_destroyed)
	$VBoxContainer/ReplayButton.grab_focus()
	$VBoxContainer/ReplayButton.pressed.connect(SoundHandler.select.play)
	SoundHandler.enable_slow_music(true)
	
	
func _on_replay_button_pressed() -> void:
	get_tree().change_scene_to_file("res://src/game.tscn")


func _on_fullscreen_button_pressed() -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	elif DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
