extends Area2D

@export var max_hp := 100
@export var flicker_interval := 0.05

@onready var sprite := $Sprite2D
var hp := max_hp
var flickering := false

func _ready():
	hp = max_hp

func take_damage(amount := 1):
	if hp <= 0:
		return

	hp -= amount
	print(name, " HP:", hp)

	if not flickering:
		flicker()

	if hp <= 0:
		die()

func flicker():
	flickering = true
	for i in range(6):
		sprite.visible = false
		await get_tree().create_timer(flicker_interval).timeout
		sprite.visible = true
		await get_tree().create_timer(flicker_interval).timeout
	flickering = false

func die():
	print(name, " destroyed")
	queue_free()
