extends Area2D

@export var max_health := 100
var health := max_health

@onready var health_bar := $HealthBar
@onready var sprite := $Sprite2D

var flicker_time := 0.1  # seconds per flicker
var flicker_count_total := 4
var flicker_timer := 0.0
var flicker_phase := false
var flicker_count := 0
var flickering := false

func _ready():
	_update_health_bar()

func take_damage(amount: int) -> void:
	health -= amount
	health = max(health, 0)
	_update_health_bar()
	_start_flicker()
	
	if health == 0:
		_die()

func _update_health_bar() -> void:
	if health_bar:
		health_bar.value = health / max_health * 100

func _start_flicker() -> void:
	flicker_timer = flicker_time
	flicker_phase = true
	flicker_count = flicker_count_total
	flickering = true

func _process(delta: float) -> void:
	if flickering:
		flicker_timer -= delta
		if flicker_timer <= 0:
			flicker_timer = flicker_time
			flicker_phase = not flicker_phase
			sprite.visible = flicker_phase
			flicker_count -= 1
			if flicker_count <= 0:
				flickering = false
				sprite.visible = true

func _die() -> void:
	print("Target died!")
	queue_free()
