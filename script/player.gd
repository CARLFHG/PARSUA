extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_sound: AudioStreamPlayer2D = $"jump sound"
@onready var wave_sfx: AudioStreamPlayer2D = $WaveSound
@onready var wind_sfx: AudioStreamPlayer2D = $WindSound

@export var wave_scene: PackedScene = preload("res://scene/wave_projectile.tscn")
@export var wind_scene: PackedScene = preload("res://scene/wind_projectile.tscn")

const SPEED = 300.0
const JUMP_VELOCITY = -650.0

func _physics_process(delta: float) -> void:
	# 1. Apply Gravity and Jumping
	if not is_on_floor():
		velocity += get_gravity() * delta
		animated_sprite_2d.animation = "jumping"
	else:
		if velocity.x != 0:
			animated_sprite_2d.animation = "running"
		else:
			animated_sprite_2d.animation = "idling"

	# 2. Jump Input - This will NO LONGER trigger buttons if Focus is None
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_sound.play()

	# 3. Horizontal Movement
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		animated_sprite_2d.flip_h = (direction < 0)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

# --- Summoning Functions ---

func _on_wave_button_pressed() -> void:
	if wave_scene:
		# REMOVED: if wave_sfx: wave_sfx.play() 
		var wave = wave_scene.instantiate()
		get_tree().current_scene.add_child(wave)
		
		var spawn_pos = global_position
		var move_dir = 1
		
		if animated_sprite_2d.flip_h: # Facing Left
			spawn_pos.x += 180 
			move_dir = -1
		else: # Facing Right
			spawn_pos.x -= 180 
			move_dir = 1
			
		spawn_pos.y += 115 
		wave.global_position = spawn_pos
		
		if wave.has_method("set_direction"):
			wave.set_direction(move_dir)

func _on_wind_button_pressed() -> void:
	if wind_scene:
		# REMOVED: if wind_sfx: wind_sfx.play()
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


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
