extends Area2D

@export var damage_per_second := 20.0

func _physics_process(delta):
	if not monitoring:
		return

	for body in get_overlapping_bodies():
		if body.is_in_group("player"):
			body.take_damage(damage_per_second * delta)
