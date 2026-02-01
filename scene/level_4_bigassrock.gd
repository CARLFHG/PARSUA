extends StaticBody2D

@export var max_health: int = 1000
var health: int = 1000 # Fixes the error in image_cd579b.jpg
@onready var sprite = $Sprite2D
@onready var health_bar = $ProgressBar
@onready var hitsound: AudioStreamPlayer2D = $hitsound


func _ready():
	health = max_health
	health_bar.max_value = max_health
	health_bar.value = health
	
	var style = StyleBoxFlat.new()
	style.bg_color = Color.GREEN
	health_bar.add_theme_stylebox_override("fill", style)

func take_damage(amount, color = Color.WHITE):
	health -= amount
	health_bar.value = health 
	
	if hitsound:
		# If it's a constant hit (like spray/rain), we want it to keep making noise
		# If the sound finished or isn't playing, start it again
		if not hitsound.playing:
			hitsound.play()
	
	sprite.modulate = color 
	play_effects() 
	shake()
	
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color.WHITE
	
	if health <= 0:
		queue_free()
func play_effects():
	var tween = get_tree().create_tween()
	var bar_style = health_bar.get_theme_stylebox("fill")
	
	tween.parallel().tween_property(sprite, "self_modulate", Color(5, 5, 5, 1), 0.05)
	tween.parallel().tween_property(bar_style, "bg_color", Color.RED, 0.05)
	
	tween.tween_property(sprite, "self_modulate", Color.WHITE, 0.05)
	tween.tween_property(bar_style, "bg_color", Color.GREEN, 0.1)
	
	
	# Add this to level_4_bigassrock.gd
func shake():
	var tween = get_tree().create_tween()
	# Move the sprite back and forth quickly
	tween.tween_property($Sprite2D, "position:x", 10, 0.05)
	tween.tween_property($Sprite2D, "position:x", -10, 0.05)
	tween.tween_property($Sprite2D, "position:x", 5, 0.05)
	tween.tween_property($Sprite2D, "position:x", 0, 0.05)
