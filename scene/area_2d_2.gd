extends Area2D

@export var health := 100
var flickering := false

func take_damage(amount: int):
	if flickering: return
	
	health -= amount
	print("Enemy Health: ", health)
	
	_flicker_effect()
	
	if health <= 0:
		queue_free()

func _flicker_effect():
	flickering = true
	var tween = create_tween()
	# Creates a quick 3-pulse flicker by changing transparency (Alpha)
	for i in range(3):
		tween.tween_property(self, "modulate:a", 0.0, 0.05)
		tween.tween_property(self, "modulate:a", 1.0, 0.05)
	
	await tween.finished
	flickering = false
