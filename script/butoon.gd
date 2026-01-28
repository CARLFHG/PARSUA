extends Node2D
@onready var element = $Element

func _on_button_pressed():
	element.position.x = -200  # reset start position

	var tween = create_tween()
	tween.tween_property(
		element,
		"position:x",
		50,       # target X position
		0.5       # duration (seconds)
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
