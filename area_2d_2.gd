extends Area2D

@export var max_health := 100
var health := max_health

@onready var sprite: Sprite2D = $Sprite2D
@onready var bar_bg: ColorRect = $HealthBarBG
@onready var bar: ColorRect = $HealthBarBG/HealthBar

@export var flicker_times := 4
@export var flicker_interval := 0.08

var flickering := false


	

func take_damage(amount: int):
	if flickering:
		return


	health -= amount
	health = max(health, 0)

	
	_flicker()

	if health <= 0:
		queue_free()




func _flicker():
	flickering = true
	for i in flicker_times:
		sprite.visible = false
		await get_tree().create_timer(flicker_interval).timeout
		sprite.visible = true
		await get_tree().create_timer(flicker_interval).timeout
	flickering = false
	
