extends CanvasLayer

func _ready() -> void:
	update_dolla_state(false)

func update_trans(transfluid: float) -> void:
	$UI/HBox/TransBar.value = transfluid

func update_score(score: int) -> void:
	$UI/HBox/Score.text = str(score)

func update_dolla_state(has_fivedolla: bool) -> void:
	$UI/HBox/FiveDolla.visible = has_fivedolla
