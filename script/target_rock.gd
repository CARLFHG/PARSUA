extends StaticBody2D # Enables physical collision so you can't walk through it

# Health and State Variable
@export var max_health := 100
var health := max_health

# --- Image Array ---
@export var rock_visuals: Array[Texture2D] 

# References to Child Nodes
@onready var sprite: Sprite2D = $Sprite2D
@onready var health_bar: ProgressBar = $HealthBar 

# Flicker Settings
@export var flicker_times := 4
@export var flicker_interval := 0.08
var flickering := false

# Sliding Settings
@export var slide_duration: float = 0.6

func _ready():
	# Resets internal positions to ensure the rock isn't offset to the left
	if sprite:
		sprite.position = Vector2.ZERO
	
	if health_bar:
		health_bar.max_value = max_health
		health_bar.value = health
	
	# Forces the first visual to show immediately
	_update_visuals()

func slide_to_center():
	var screen_size = get_viewport_rect().size
	var target_x = screen_size.x / 2
	
	var tween = create_tween()
	tween.tween_property(self, "position:x", target_x, slide_duration)\
		.set_trans(Tween.TRANS_QUART)\
		.set_ease(Tween.EASE_OUT)

func take_damage(amount: int):
	if flickering:
		return
	
	health -= amount
	health = max(health, 0)
	
	_update_health_bar()
	_update_visuals()
	_flicker()
	
	if health <= 0:
		die()

func _update_health_bar():
	if health_bar:
		health_bar.value = health

func _update_visuals():
	# If the array is empty, we can't display an image
	if rock_visuals.size() == 0:
		return
		
	var health_percent = float(health) / max_health
	var index = 0
	
	# Determine damage stage
	if health_percent >= 0.75: 
		index = 0   
	elif health_percent >= 0.50: 
		index = 1   
	elif health_percent >= 0.25: 
		index = 2   
	else: 
		index = 3   
	
	# Safety check: uses whatever images you have available without crashing
	var final_index = clampi(index, 0, rock_visuals.size() - 1)
	sprite.texture = rock_visuals[final_index]

func _flicker():
	flickering = true
	for i in flicker_times:
		sprite.modulate = Color(10, 10, 10) # Bright white flash
		await get_tree().create_timer(flicker_interval).timeout
		sprite.modulate = Color(1, 1, 1) # Normal color
		await get_tree().create_timer(flicker_interval).timeout
	flickering = false

func die():
	# Disables collision so you can pass through the "broken" rock
	$CollisionShape2D.set_deferred("disabled", true)
	
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.5, 0.5) # Fades out
