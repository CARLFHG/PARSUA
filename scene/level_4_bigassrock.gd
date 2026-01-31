extends StaticBody2D

@export var max_health: int = 100
var current_health: int = 100

@onready var sprite = $Sprite2D
@onready var health_bar = $ProgressBar

func _ready():
	current_health = max_health
	health_bar.max_value = max_health
	health_bar.value = current_health
	
	# Create a unique style so we can change colors without affecting other bars
	var style = StyleBoxFlat.new()
	style.bg_color = Color.GREEN
	health_bar.add_theme_stylebox_override("fill", style)

func take_damage(amount: int):
	current_health -= amount
	health_bar.value = current_health
	
	play_effects()
	
	if current_health <= 0:
		die()

func play_effects():
	var tween = get_tree().create_tween()
	var bar_style = health_bar.get_theme_stylebox("fill")
	
	# 1. Rock flashes White (Overbright modulate)
	tween.parallel().tween_property(sprite, "self_modulate", Color(10, 10, 10, 1), 0.05)
	
	# 2. Bar turns Red
	tween.parallel().tween_property(bar_style, "bg_color", Color.RED, 0.05)
	
	# 3. Return to normal
	tween.tween_property(sprite, "self_modulate", Color.WHITE, 0.05)
	tween.tween_property(bar_style, "bg_color", Color.GREEN, 0.1)

func die():
	queue_free()
