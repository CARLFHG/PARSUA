extends AnimatedSprite2D

@export var slide_duration: float = 0.6

func _ready():
	# 1. Start off-screen to the left
	# We use get_viewport_rect().size to find the screen boundaries
	var screen_size = get_viewport_rect().size
	
	# Position Y in the middle, X off-screen
	position.y = screen_size.y / 2
	position.x = -200 # Adjust this based on how wide your sprite is

func _on_button_pressed():
	# 2. Play the animation and slide in
	play("your_animation_name") # Replace with your actual animation name
	slide_to_center()

func slide_to_center():
	var screen_size = get_viewport_rect().size
	var target_x = screen_size.x / 2
	
	var tween = create_tween()
	# Using TRANS_ELASTIC or TRANS_BACK gives animations a "bouncy" feel
	tween.tween_property(self, "position:x", target_x, slide_duration)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)
