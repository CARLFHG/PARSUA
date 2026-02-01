extends StaticBody2D

@onready var sprite = $Sprite2D
@onready var health_bar = $HealthBar

var max_health = 100.0
var current_health = 100.0

func _ready():
	sprite.animation = "blown away"
	sprite.frame = 0
	sprite.stop() 

func take_damage(amount):
	current_health = clamp(current_health - amount, 0, max_health)
	
	# Update the UI HealthBar
	health_bar.value = current_health
	
	# Map health to frames
	update_sprite_frame()

	# Check if the rock should disappear
	if current_health <= 0:
		destroy_rock()

func update_sprite_frame():
	var frame_count = sprite.sprite_frames.get_frame_count("blown away")
	var health_percent = current_health / max_health
	
	# Math: (1 - percentage) * last_frame_index
	var target_frame = int((1.0 - health_percent) * (frame_count - 1))
	sprite.frame = target_frame

func destroy_rock():
	# You can add a particle effect or sound here before deleting
	queue_free()
