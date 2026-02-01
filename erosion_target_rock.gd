extends StaticBody2D

@onready var sprite = $Sprite2D
@onready var health_bar = $HealthBar
@onready var collision = $CollisionShape2D # Reference your collision shape

@export var max_health: float = 100.0
@onready var current_health: float = max_health 

func _ready():
	if sprite:
		sprite.animation = "blown away"
		sprite.frame = 0
		sprite.stop() 
	
	if health_bar:
		health_bar.max_value = max_health
		health_bar.value = current_health

func take_damage(amount: float, flash_color: Color = Color.WHITE):
	if current_health <= 0:
		return
		
	current_health = clamp(current_health - amount, 0.0, max_health)
	
	# Update UI
	if health_bar:
		health_bar.value = current_health
	
	# Visual feedback: Flash the rock with the color sent by the agent
	var tween = create_tween()
	sprite.modulate = flash_color * 1.5 # Make it glow slightly
	tween.tween_property(sprite, "modulate", Color.WHITE, 0.1)
	
	update_sprite_frame()

	if current_health <= 0:
		destroy_rock()

func update_sprite_frame():
	if not sprite or not sprite.sprite_frames:
		return
		
	var frame_count = sprite.sprite_frames.get_frame_count("blown away")
	var health_percent = current_health / max_health if max_health > 0 else 0.0
	var target_frame = int((1.0 - health_percent) * (frame_count - 1))
	
	sprite.frame = clampi(target_frame, 0, frame_count - 1)

func destroy_rock():
	# 1. Hide the health bar immediately
	if health_bar:
		health_bar.hide()
	
	# 2. Disable collision so objects pass through it
	if has_node("CollisionShape2D"):
		$CollisionShape2D.set_deferred("disabled", true)
	
	# 3. Define the movement
	# This calculates a position 100 pixels to the right and 20 pixels up
	var settle_position = global_position + Vector2(100, -20) 
	
	# 4. Create the Tween for movement and fade
	var tween = create_tween().set_parallel(true) # Allows moving and fading at the same time
	
	# Slide to the new position
	tween.tween_property(self, "global_position", settle_position, 2.0)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)
		
	# Fade to 50% opacity
	tween.tween_property(sprite, "modulate:a", 0.5, 2.0)
	
	# Optional: Slight rotation to make it look like it tumbled
	tween.tween_property(sprite, "rotation_degrees", 15.0, 2.0)

	print("Rock has moved and settled.")
