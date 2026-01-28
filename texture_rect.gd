extends TextureRect

@export var slide_duration: float = 0.5

func _ready():
	# 1. Position it vertically in the center and horizontally off-screen to the left
	var screen_size = get_viewport_rect().size
	position.y = (screen_size.y / 2) - (size.y / 2)
	position.x = -size.x # Start completely hidden to the left

func _on_button_pressed():
	slide_to_center()

func slide_to_center():
	var screen_size = get_viewport_rect().size
	# 2. Calculate the horizontal center point
	var target_x = (screen_size.x / 2) - (size.x / 2)
	
	var tween = create_tween()
	# 3. Animate to the center
	tween.tween_property(self, "position:x", target_x, slide_duration)\
		.set_trans(Tween.TRANS_QUART)\
		.set_ease(Tween.EASE_OUT)
