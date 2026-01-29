extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_sound: AudioStreamPlayer2D = $"jump sound"



const SPEED = 300.0
const JUMP_VELOCITY = -650.0



func _physics_process(delta: float) -> void:
	
	#animation sa movement
	if velocity.x > 1 or velocity.x < -1:
		animated_sprite_2d.animation = "running"
	else:
		animated_sprite_2d.animation = "idling"
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		animated_sprite_2d.animation = "jumping"
		
		
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_sound.play()
		
	#movements
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	if direction == 1.0:
		animated_sprite_2d.flip_h = false
	elif direction == -1.0:
		animated_sprite_2d.flip_h = true
		

func _on_checkpoint_body_entered(body: Node2D) -> void:
	print("Something touched the checkpoint: ", body.name) # Check your 'Output' tab!
	
	if body.name == "player":
		print("Player detected! Changing scene...")
		var error = get_tree().change_scene_to_file("res://main_menu.tscn")
		
		if error != OK:
			print("ERROR: Could not find the main menu file!")
