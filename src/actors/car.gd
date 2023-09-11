extends Area2D

var EXPLOSION_SCENE = preload("res://src/actors/car_explosion.tscn")

var fast := true
var speed := 2

func _ready() -> void:
	match randi_range(0, 2):
		0:
			$Sprite.play("car")
		1:
			$Sprite.play("truck")
		2:
			$Sprite.play("taxi")

func _physics_process(delta: float) -> void:
	if fast:
		position -= Global.cartesian_to_isometric(Vector2(0, 1)) * speed * (Global.runtime * delta)
		if global_position.y < -16 || global_position.x > 480: # todo i tihnk lol
			queue_free()
	else:
		position += Global.cartesian_to_isometric(Vector2(0, 1)) * speed * (Global.runtime * delta)
		if global_position.y > 256 || global_position.x < -16:
			queue_free()

func die() -> void:
	var explosion = EXPLOSION_SCENE.instantiate()
	explosion.global_position = global_position
	get_parent().get_parent().get_node("Actors").add_child(explosion)
	queue_free()
