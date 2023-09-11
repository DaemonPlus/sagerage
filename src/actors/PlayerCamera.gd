extends Camera2D

var amplitude = 0
var priority = 0

func start_shake(dur := 0.2, freq := 15, amp := 16.0, pri := 0):
	if (pri >= self.priority):
		self.priority = pri
		self.amplitude = amp

		$Duration.wait_time = dur
		$Frequency.wait_time = 1.0 / float(freq)
		$Duration.start()
		$Frequency.start()

		_new_shake()

func _new_shake():
	var rand = Vector2(randf_range(-amplitude, amplitude), randf_range(-amplitude, amplitude))

	var tween = get_tree().create_tween()
	tween.tween_property(self, "offset", rand, $Frequency.wait_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _reset():
	var reset_tween = get_tree().create_tween()
	reset_tween.tween_property(self, "offset", Vector2.ZERO, $Frequency.wait_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	priority = 0


func _on_frequency_timeout() -> void:
	_new_shake()


func _on_duration_timeout() -> void:
	_reset()
	$Frequency.stop()
