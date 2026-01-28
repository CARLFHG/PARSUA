extends StaticBody2D

@export var health := 100
var flickering := false

func take_damage(amount: int):
	# If already flickering, don't trigger it again immediately
	if flickering: return
	
	health -= amount
	print("Enemy Hit! Health remaining: ", health)
	
	_play_flicker()
	
	if health <= 0:
		queue_free()

func _play_flicker():
	flickering = true
	var tween = create_tween()
	
	# Flicker 4 times by swapping transparency
	for i in range(4):
		tween.tween_property(self, "modulate:a", 0.1, 0.07) # Fade out
		tween.tween_property(self, "modulate:a", 1.0, 0.07) # Fade in
	
	await tween.finished
	flickering = false
