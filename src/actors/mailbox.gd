extends Area2D

var score_value := 1

func hit():
	$Sprite.set_frame(1)
	$CollisionPolygon2D.set_deferred("disabled", true)
