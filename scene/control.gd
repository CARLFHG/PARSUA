extends Control

@export var world_offset: Vector2 = Vector2(0, -60) # above player
@export var follow_speed: float = 12.0               # higher = snappier

@onready var player: Node2D = get_node("/root/Main/Player")

var camera: Camera2D

func _ready():
	# start at correct position immediately
	camera = get_viewport().get_camera_2d()
	_update_position(1.0)

func _process(delta):
	if not is_instance_valid(player):
		return

	if not camera:
		camera = get_viewport().get_camera_2d()
		return

	_update_position(delta)

func _update_position(delta):
	# world → screen
	var target_screen_pos: Vector2 = camera.unproject_position(
		player.global_position + world_offset
	)

	# smooth follow
	global_position = global_position.lerp(
		target_screen_pos,
		follow_speed * delta
	)
