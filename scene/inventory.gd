extends Sprite2D
@export var screen_offset := Vector2(0, 200)

@onready var camera: Camera2D = $"../Camera2D"

func _process(delta):
	if camera:
		global_position = camera.get_screen_center_position() + screen_offset
