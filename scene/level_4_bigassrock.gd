extends StaticBody2D

@export var max_health: int = 1000
var health: int = 1000 
@onready var sprite = $Sprite2D
@onready var health_bar = $ProgressBar
@onready var hitsound: AudioStreamPlayer2D = $hitsound
@onready var death_video = $DeathVideo # The VideoStreamPlayer node

func _ready():
	health = max_health
	health_bar.max_value = max_health
	health_bar.value = health
	death_video.hide() # Keep hidden until the rock breaks
	
	# Match video size to sprite size
	if sprite.texture:
		var sprite_size = sprite.texture.get_size()
		death_video.custom_minimum_size = sprite_size
		death_video.size = sprite_size
		# Centers the video if it's not already centered
		death_video.position = -sprite_size / 2 
	
	var style = StyleBoxFlat.new()
	style.bg_color = Color.GREEN
	health_bar.add_theme_stylebox_override("fill", style)

func take_damage(amount, color = Color.WHITE):
	if health <= 0: return # Don't take damage if already dying
	
	health -= amount
	health_bar.value = health 
	
	if hitsound:
		if not hitsound.playing:
			hitsound.play()
	
	sprite.modulate = color 
	play_effects() 
	shake()
	
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color.WHITE
	
	if health <= 0:
		die() 

func die():
	# 1. Disable all collisions
	$hitbox/CollisionShape2D.set_deferred("disabled", true)
	$CollisionShape2D.set_deferred("disabled", true)
	health_bar.hide()
	
	# 2. Swap Sprite for Video
	sprite.hide()
	death_video.show()
	death_video.play() 
	
	# 3. Stop the video at 4 seconds as requested
	await get_tree().create_timer(4.0).timeout 
	death_video.stop() 
	
	# 4. Wait 3 seconds while looking at the frozen frame
	await get_tree().create_timer(3.0).timeout
	
	# 5. Switch to your Ending Cutscene Scene
	get_tree().change_scene_to_file("res://scene/ending_cutscene.tscn")
	
func play_effects():
	var tween = get_tree().create_tween()
	var bar_style = health_bar.get_theme_stylebox("fill")
	tween.parallel().tween_property(sprite, "self_modulate", Color(5, 5, 5, 1), 0.05)
	tween.parallel().tween_property(bar_style, "bg_color", Color.RED, 0.05)
	tween.tween_property(sprite, "self_modulate", Color.WHITE, 0.05)
	tween.tween_property(bar_style, "bg_color", Color.GREEN, 0.1)

func shake():
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "position:x", 10, 0.05)
	tween.tween_property($Sprite2D, "position:x", -10, 0.05)
	tween.tween_property($Sprite2D, "position:x", 5, 0.05)
	tween.tween_property($Sprite2D, "position:x", 0, 0.05)
