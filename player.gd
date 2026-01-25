extends CharacterBody2D

@export var speed := 200  # movement speed

func _process(delta):
	# Player movement
	var input_dir = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		input_dir.x += 1
	if Input.is_action_pressed("ui_left"):
		input_dir.x -= 1

	velocity.x = input_dir.x * speed
	move_and_slide()
