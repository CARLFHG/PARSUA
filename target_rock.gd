extends Area2D

@export var max_health := 100
var health := max_health

func take_damage(amount: int) -> void:
	health -= amount
	print("Health:", health)

	if health <= 0:
		die()

func die():
	queue_free() # removes the image
