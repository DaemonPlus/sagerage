extends Node2D

var TRANSBOTTLE_SCENE = preload("res://src/actors/trans_bottle.tscn")
var MAILBOX_SCENE = preload("res://src/actors/mailbox.tscn")
var CAR_SCENE = preload("res://src/actors/car.tscn")
var LEFTY_SCENE = preload("res://src/actors/lefty.tscn")
var FIVEDOLLA_SCENE = preload("res://src/actors/five_dolla.tscn")
var ROOT_SCENE = preload("res://src/actors/root.tscn")

var ROOTNO_SCENE = preload("res://src/root_no.tscn")

func _ready() -> void:
	Global.runtime = 0.0
	Global.results_data = {
		"score": 0,
		"total_bills_collected": 0,
		"lefty_attacks": 0,
		"lefties_purchased": 0,
		"cars_destroyed": 0,
		"transmission_fluid_collected": 0,
		"root_hit": false
	}
	SoundHandler.gamemusic.play()
	SoundHandler.enable_slow_music(false)

func _physics_process(delta: float) -> void:
	for child in $Actors.get_children():
		child.position += Global.cartesian_to_isometric(Vector2(0, 1)) * Global.speed * (Global.runtime * delta + 1)
		if child.global_position.y > 256 || child.global_position.x < -16:
			child.queue_free()

func _process(delta: float) -> void:
	Global.runtime += delta


func _on_sage_truck_out_of_transfluid() -> void:
	get_tree().change_scene_to_file("res://src/results_screen.tscn")

func gen_spawn_pos() -> Vector2:
	return Vector2(randf_range(0, 640), 0)

func gen_road_top_spawn_pos() -> Vector2:
	return Vector2(randf_range(320, 640), 0)

func gen_road_bottom_spawn_pos() -> Vector2:
	return Vector2(0, randf_range(300, 480))

func gen_sidewalk_spawn_pos() -> Vector2:
	return Vector2(randf_range(250, 300), 0)

func gen_lawn_spawn_pos() -> Vector2:
	return Vector2(randf_range(0, 240), 0)

func gen_mailbox_spawn_pos() -> Vector2:
	return Vector2(randf_range(120, 240), 0)


func _on_road_spawn_timer_timeout() -> void:
	var transbottle = TRANSBOTTLE_SCENE.instantiate()
	transbottle.global_position = gen_road_top_spawn_pos()
	$Actors.add_child(transbottle)
	$RoadSpawnTimer.wait_time = clampf($RoadSpawnTimer.wait_time - Global.runtime * 0.0005, 0.75, 2)


func _on_mailbox_spawn_timer_timeout() -> void:
	var mailbox = MAILBOX_SCENE.instantiate()
	mailbox.global_position = gen_mailbox_spawn_pos()
	$Actors.add_child(mailbox)
	$MailboxSpawnTimer.wait_time = clampf($MailboxSpawnTimer.wait_time - Global.runtime * 0.0005, 0.5, 3)


func _on_car_spawn_timer_timeout() -> void:
	var car = CAR_SCENE.instantiate()
	if randi_range(0, 1) == 0:
		car.global_position = gen_road_top_spawn_pos()
		car.fast = false
	else:
		car.global_position = gen_road_bottom_spawn_pos()
		car.fast = true
	$MovingActors.add_child(car)
	$CarSpawnTimer.wait_time = clampf($CarSpawnTimer.wait_time - Global.runtime * 0.01, 0.5, 3)


func _on_lefty_spawn_timer_timeout() -> void:
	var lefty = LEFTY_SCENE.instantiate()
	lefty.global_position = gen_spawn_pos()
	$Actors.add_child(lefty)
	$LeftySpawnTimer.wait_time = clampf($LeftySpawnTimer.wait_time - Global.runtime * 0.0001, 1, 4)


func _on_five_dolla_timer_timeout() -> void:
	var fivedolla = FIVEDOLLA_SCENE.instantiate()
	fivedolla.global_position = gen_sidewalk_spawn_pos()
	$Actors.add_child(fivedolla)
	$FiveDollaTimer.wait_time = clampf($FiveDollaTimer.wait_time - Global.runtime * 0.0001, 3, 8)


func _on_root_spawn_timer_timeout() -> void:
	if !Global.results_data.root_hit:
		var root = ROOT_SCENE.instantiate()
		root.global_position = gen_sidewalk_spawn_pos()
		$Actors.add_child(root)
		$RootSpawnTimer.wait_time = clampf($RootSpawnTimer.wait_time - Global.runtime * 0.0001, 30, 45)


func _on_sage_truck_mailbox_hit() -> void:
	Global.results_data.score += 1
	$UI.update_score(Global.results_data.score)


func _on_sage_truck_car_hit() -> void:
	Global.results_data.cars_destroyed += 1


func _on_sage_truck_fivedolla_collected() -> void:
	Global.results_data.total_bills_collected += 1
	if Global.results_data.total_bills_collected >= 20:
		if OS.has_feature("ngio"):
				JavaScriptBridge.eval("unlockMedal('Hundredaire');")
	$UI.update_dolla_state(true)


func _on_sage_truck_lefty_hit() -> void:
	Global.results_data.lefty_attacks += 1
	if Global.results_data.lefty_attacks >= 5 && Global.results_data.total_bills_collected == 0:
		if OS.has_feature("ngio"):
				JavaScriptBridge.eval("unlockMedal('Cheapskate');")


func _on_sage_truck_lefty_purchased() -> void:
	Global.results_data.lefties_purchased += 1
	$UI.update_dolla_state(false)


func _on_sage_truck_update_trans(transfluid) -> void:
	$UI.update_trans(transfluid)


func _on_sage_truck_trans_collected() -> void:
	Global.results_data.transmission_fluid_collected += 1


func _on_sage_truck_root_hit() -> void:
	Global.results_data.root_hit = true
	$RootSpawnTimer.stop()
	
	var rootno = ROOTNO_SCENE.instantiate()
	add_child(rootno)
