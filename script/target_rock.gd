extends Area2D

# Health and State Variable
@export var max_health := 100
var health := max_health

# --- NEW: Image Array ---
@export var rock_visuals: Array[Texture2D] 

# References to Child Nodes (Updated to match your screenshot)
@onready var sprite: Sprite2D = $Sprite2D
# In your screenshot, HealthBar is a child of Sprite2D
@onready var health_bar: ProgressBar = $Sprite2D/HealthBar 

# Flicker Settings
@export var flicker_times := 4
@export var flicker_interval := 0.08
var flickering := false

# Sliding Settings
@export var slide_duration: float = 0.6

func _ready():
	# Set the health bar range based on max health
	if health_bar:
		health_bar.max_value = max_health
		health_bar.value = health
		
	position.x = -200
	# Set the initial texture immediately on spawn
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
	
	print("Damage taken! Current Health: ", health)
	
	_update_health_bar()
	_update_visuals()
	_flicker()
	
	if health <= 0:
		die()

func _update_health_bar():
	if health_bar:
		# ProgressBars update their own width automatically using the 'value' property
		health_bar.value = health

func _update_visuals():
	if rock_visuals.size() < 4:
		return
		
	var health_percent = float(health) / max_health
	var index = 0
	
	if health_percent >= 0.75: 
		index = 0   
	elif health_percent >= 0.50: 
		index = 1   
	elif health_percent >= 0.25: 
		index = 2   
	else: 
		index = 3   
	
	sprite.texture = rock_visuals[index]

func _flicker():
	flickering = true
	for i in flicker_times:
		sprite.modulate = Color(10, 1, 1) # Flash Red
		await get_tree().create_timer(flicker_interval).timeout
		
		sprite.modulate = Color(1, 1, 1) # Normal
		await get_tree().create_timer(flicker_interval).timeout
	flickering = false

func die():
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.3)
	tween.finished.connect(queue_free)
