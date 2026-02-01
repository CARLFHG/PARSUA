extends StaticBody2D # Enables physical collision so you can't walk through it

# Health and State Variable
@export var max_health := 100
var health := max_health

# --- Image Array ---
# IMPORTANT: Drag your 4 rock textures into this array in the Inspector!
@export var rock_visuals: Array[Texture2D] 

# References to Child Nodes
@onready var sprite: Sprite2D = $Sprite2D
@onready var health_bar: ProgressBar = $HealthBar 

# Flicker Settings
@export var flicker_times := 4
@export var flicker_interval := 0.08
var flickering := false
var current_flash_color := Color.WHITE # Dynamic color for red/blue flicker

# Sliding Settings
@export var slide_duration: float = 0.6

func _ready():
	# --- VISIBILITY SAFETY ---
	show()
	if sprite:
		sprite.position = Vector2.ZERO
		sprite.modulate.a = 1.0 # Ensure it starts fully visible
	
	if health_bar:
		health_bar.max_value = max_health
		health_bar.value = health
		health_bar.show() # Ensure health bar is visible at start
	
	# Forces the first visual to show immediately if images exist
	if rock_visuals.size() > 0:
		_update_visuals()
	else:
		print("Warning: No textures found in Rock Visuals array!")

func slide_to_center():
	var screen_size = get_viewport_rect().size
	var target_x = screen_size.x / 2
	
	var tween = create_tween()
	tween.tween_property(self, "position:x", target_x, slide_duration)\
		.set_trans(Tween.TRANS_QUART)\
		.set_ease(Tween.EASE_OUT)

# Called by Cloud, Wave, Spray, or Temperature tools
func take_damage(amount: int, flash_color: Color = Color.BLUE):
	if flickering or health <= 0:
		return
	
	health -= amount
	health = max(health, 0)
	current_flash_color = flash_color # Update color (e.g., Red or Blue)
	
	_update_health_bar()
	_update_visuals()
	_flicker()
	
	if health <= 0:
		die()

func _update_health_bar():
	if health_bar:
		health_bar.value = health

func _update_visuals():
	if rock_visuals.size() == 0:
		return
		
	var health_percent = float(health) / max_health
	var index = 0
	
	# Determine damage stage based on health remaining
	if health_percent >= 0.75: 
		index = 0    
	elif health_percent >= 0.50: 
		index = 1    
	elif health_percent >= 0.25: 
		index = 2    
	else: 
		index = 3 # Final cracked frame
	
	var final_index = clampi(index, 0, rock_visuals.size() - 1)
	
	# Only update if the texture slot isn't empty
	if rock_visuals[final_index] != null:
		sprite.texture = rock_visuals[final_index]

func _flicker():
	flickering = true
	for i in flicker_times:
		# Multiplied color makes it glow/flash brightly
		sprite.modulate = current_flash_color * 5 
		await get_tree().create_timer(flicker_interval).timeout
		sprite.modulate = Color(1, 1, 1) # Back to normal
		await get_tree().create_timer(flicker_interval).timeout
	flickering = false

func die():
	# 1. Disable collision so you can pass through the rock
	$CollisionShape2D.set_deferred("disabled", true)
	
	# 2. Hide health bar
	if health_bar:
		health_bar.hide()
	
	# 3. Stay in the last frame, but fade to semi-transparent
	var tween = create_tween()
	tween.tween_property(sprite, "modulate:a", 0.5, 1.0) # 50% opacity
