extends Area2D

var hp := 50

func take_damage(amount):
	hp -= amount
	print("Hit! HP:", hp)
	if hp <= 0:
		queue_free()
