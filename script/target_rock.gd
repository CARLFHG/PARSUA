extends Area2D

# Health and State Variable
@export var max_health := 100
var health := max_health

# --- NEW: Image Array ---
@export var rock_visuals: Array[Texture2D] 

# References to Child Nodes
@onready var sprite: Sprite2D = $Sprite2D
@onready var bar_bg: ColorRect = $HealthBarBG
@onready var bar: ColorRect = $HealthBarBG/HealthBar

# Flicker Settings
@export var flicker_times := 4
@export var flicker_interval := 0.08
var flickering := false

# Sliding Settings
@export var slide_duration: float = 0.6

func _ready():
	position.x = -200
	_update_health_bar()
	# Set the initial texture immediately on spawn
	_update_visuals()

func _on_button_pressed():
	slide_to_center()

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
	
	# CHECK OUTPUT: See if this number is actually going down
	print("Damage taken! Current Health: ", health)
	
	_update_health_bar()
	_update_visuals()
	_flicker()
	
	if health <= 0:
		die()

func _update_health_bar():
	if bar_bg and bar:
		var health_ratio = float(health) / max_health
		bar.size.x = bar_bg.size.x * health_ratio

func _update_visuals():
	# If the array is empty or not set up, don't run this
	if rock_visuals.size() < 4:
		return
		
	var health_percent = float(health) / max_health
	var index = 0
	
	# UPDATED LOGIC: Using >= ensures images change at exactly the right time
	if health_percent >= 0.75: 
		index = 0   # 100% to 75%
	elif health_percent >= 0.50: 
		index = 1   # 74% to 50%
	elif health_percent >= 0.25: 
		index = 2   # 49% to 25%
	else: 
		index = 3   # 24% and below
	
	# Force the sprite to update its texture
	sprite.texture = rock_visuals[index]

func _flicker():
	flickering = true
	for i in flicker_times:
		sprite.visible = false
		await get_tree().create_timer(flicker_interval).timeout
		sprite.visible = true
		await get_tree().create_timer(flicker_interval).timeout
	flickering = false

func die():
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.3)
	tween.finished.connect(queue_free)
