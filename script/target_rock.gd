extends Area2D

# Health and State Variable

@export var max_health := 100
var health := max_health

# References to Child Nodes (Check these names in your Scene Tree!)
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
	# Optional: Set initial position off-screen left
	position.x = -200

func _on_button_pressed():
	# Trigger the slide to center when button is clicked
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
	
	# Update health bar logic would go here
	print("Health: ", health)
	
	_flicker()
	
	if health <= 0:
		die()

func _flicker():
	flickering = true
	for i in flicker_times:
		sprite.visible = false
		await get_tree().create_timer(flicker_interval).timeout
		sprite.visible = true
		await get_tree().create_timer(flicker_interval).timeout
	flickering = false

func die():
	queue_free() # Removes the node from the scene
