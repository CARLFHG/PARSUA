extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_sound: AudioStreamPlayer2D = $"jump sound"

# 1. Add these new sound variables
# These must match your Scene Tree exactly!
@onready var wave_sfx: AudioStreamPlayer2D = $WaveSound
@onready var wind_sfx: AudioStreamPlayer2D = $WindSound

@export var wave_scene: PackedScene = preload("res://scene/wave_projectile.tscn")
@export var wind_scene: PackedScene = preload("res://scene/wind_projectile.tscn")

const SPEED = 300.0
const JUMP_VELOCITY = -650.0

# This function runs when you click the Wave Button in the HUD
# Inside your PLAYER script
# This function runs when you click the Wave Button
# This function runs when you click the Wave Button
func _on_wave_button_pressed() -> void:
	if wave_scene:
		var wave = wave_scene.instantiate()
		get_tree().current_scene.add_child(wave)
		
		var spawn_pos = global_position
		var move_dir = 1 # Default to right
		
		# Increase the offset to 180 to move it further behind
		if animated_sprite_2d.flip_h: # Player is facing LEFT
			spawn_pos.x += 180 # Spawn far to the right
			move_dir = -1      # But move left
		else: # Player is facing RIGHT
			spawn_pos.x -= 180 # Spawn far to the left
			move_dir = 1       # But move right
			
		spawn_pos.y += 115 
		wave.global_position = spawn_pos
		
		# Tell the wave which way to go
		if wave.has_method("set_direction"):
			wave.set_direction(move_dir)

# This function runs when you click the Wind Button
func _on_wind_button_pressed() -> void:
	if wind_scene:
		var wind = wind_scene.instantiate()
		get_tree().current_scene.add_child(wind)
		
		var spawn_pos = global_position
		var move_dir = 1
		
		if animated_sprite_2d.flip_h:
			spawn_pos.x += 180
			move_dir = -1
		else:
			spawn_pos.x -= 180
			move_dir = 1
			
		spawn_pos.y += 70
		wind.global_position = spawn_pos
		
		if wind.has_method("set_direction"):
			wind.set_direction(move_dir)
func _physics_process(delta: float) -> void:
	# (Your existing movement and animation code remains the same)
	if velocity.x > 1 or velocity.x < -1:
		animated_sprite_2d.animation = "running"
	else:
		animated_sprite_2d.animation = "idling"

	if not is_on_floor():
		velocity += get_gravity() * delta
		animated_sprite_2d.animation = "jumping"
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_sound.play()
		
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
	if body.name == "player":
		get_tree().change_scene_to_file("res://main_menu.tscn")
