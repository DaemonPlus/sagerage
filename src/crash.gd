extends Node2D


func _ready() -> void:
	$AnimationPlayer.play("crash" + str(randi_range(1, 3)))


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	queue_free()
