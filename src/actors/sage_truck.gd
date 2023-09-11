extends CharacterBody2D

var TRANSPUDDLE_SCENE = preload("res://src/actors/trans_puddle.tscn")
var JUMPSCARE_SCENE = preload("res://src/jumpscare.tscn")
var CRASH_SCENE = preload("res://src/crash.tscn")

var CASH_EXPLOSION_SCENE = preload("res://src/particles/cash_explosion_particles.tscn")
var TRANS_EXPLOSION_SCENE = preload("res://src/particles/trans_explosion_particles.tscn")
var HEART_EXPLOSION_SCENE = preload("res://src/particles/heart_particles.tscn")

var transfluid := 100.0
var trans_leak_speed := 0.035
var has_fivedollas := false

const MAX_SPEED := 250
const MAX_ACCEL := 2500

var acceleration_max := 300.0
var acceleration := acceleration_max
var friction := 3 #acceleration / speed

var traction := Vector2.ZERO

signal update_trans(transfluid: float)
signal lefty_hit
signal mailbox_hit
signal car_hit
signal lefty_purchased
signal fivedolla_collected
signal trans_collected
signal root_hit

signal out_of_transfluid


func _ready() -> void:
	emit_signal("update_trans", transfluid)
	$Camera.reset_smoothing()

func _physics_process(delta: float) -> void:
	# other
	transfluid -= trans_leak_speed + (Global.runtime * 0.005) * delta
	if transfluid > 0.0:
		acceleration_max = clampf(acceleration_max + Global.runtime * 0.05, 0.0, MAX_ACCEL)
		acceleration = acceleration_max
	if transfluid > 100.0:
		transfluid = 100.0
	elif transfluid <= 0.0:
		acceleration -= 1000.0 * delta
		if acceleration <= 0:
			emit_signal("out_of_transfluid")
	emit_signal("update_trans", transfluid)
	
	# moving
	apply_traction(delta)
	apply_friction(delta)
	set_velocity(velocity)
	
	@warning_ignore("return_value_discarded")
	move_and_slide()

func apply_traction(delta: float) -> void:
	traction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	traction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	traction = Global.cartesian_to_isometric(traction).normalized()

	velocity += traction * acceleration * delta

	velocity.x = clampf(velocity.x, -MAX_SPEED, MAX_SPEED)
	velocity.y = clampf(velocity.y, -MAX_SPEED, MAX_SPEED)
	


func apply_friction(delta: float) -> void:
	velocity -= velocity * friction * delta


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("transup"):
		transfluid += area.trans_value
		area.queue_free()
		$TransSFX.play()
		var transparticles = TRANS_EXPLOSION_SCENE.instantiate()
		transparticles.global_position = global_position
		get_parent().get_node("Actors").add_child(transparticles)
	elif area.is_in_group("mailboxes"):
		mailbox_hit.emit()
		area.hit()
		$Camera.start_shake(0.25,45,4.0,1)
		$ExplosionLoudSFX.play()
	elif area.is_in_group("cars"):
		car_hit.emit()
		transfluid -= 25
		area.die()
		var crash = CRASH_SCENE.instantiate()
		get_parent().add_child(crash)
		$Camera.start_shake(1,90,16.0,3)
		if randi_range(0, 100) > 80 && !$FuckOffSFX.is_playing():
			$FuckOffSFX.play()
	elif area.is_in_group("lefty"):
		area.queue_free()
		if has_fivedollas:
			var heartparticles = HEART_EXPLOSION_SCENE.instantiate()
			heartparticles.global_position = global_position
			get_parent().get_node("Actors").add_child(heartparticles)
			lefty_purchased.emit()
			has_fivedollas = false
			$QuirkySFX.play()
			if OS.has_feature("ngio"):
				JavaScriptBridge.eval("unlockMedal('Only $5');")
		else:
			if transfluid > 10:
				transfluid = 10
			else:
				transfluid = 0
			lefty_hit.emit()
			var jumpscare = JUMPSCARE_SCENE.instantiate()
			$Camera.start_shake(1.5,90,8.0,2)
			get_parent().add_child(jumpscare)
			if randi_range(0, 100) > 80 && !$FuckOffSFX.is_playing():
				$FuckOffSFX.play()
	elif area.is_in_group("root"):
		area.get_node("Sprite").play("dead")
		area.get_node("CollisionPolygon2D").set_deferred("monitorable", false)
		$RootDeathSFX.play()
		if OS.has_feature("ngio"):
			JavaScriptBridge.eval("unlockMedal('Hit a Dog');")
		root_hit.emit()
		$Camera.start_shake(0.5,30,8.0,1)
	elif area.is_in_group("fivedollas"):
		var cashparticles = CASH_EXPLOSION_SCENE.instantiate()
		cashparticles.global_position = global_position
		get_parent().get_node("Actors").add_child(cashparticles)
		fivedolla_collected.emit()
		area.queue_free()
		if !has_fivedollas:
			$OooSFX.play()
		has_fivedollas = true
		$KaChingSFX.play()


func _on_trans_puddle_timer_timeout() -> void:
	if transfluid > 0.0:
		var transpuddle = TRANSPUDDLE_SCENE.instantiate()
		transpuddle.global_position = global_position
		get_parent().get_node("Actors").add_child(transpuddle)
		$TransPuddleTimer.wait_time = randf_range(0.1, clamp(2-(Global.runtime*0.01),0.1,2))


func _on_tire_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("curb"):
		$Camera.start_shake(0.15,5,4.0,0)
		$CurbSFX.play()
