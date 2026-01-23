extends Area2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var drag_shape: CollisionShape2D = $CollisionShape2D

var is_dragging := false
var drag_offset: Vector2
var start_position: Vector2

# scales
var normal_scale := Vector2.ONE
var drag_scale := Vector2(10, 10)

# collision originals (stored once)
var original_radius: float
var original_rect_size: Vector2

func _ready():
	start_position = global_position
	normal_scale = sprite.scale

	if drag_shape.shape is CircleShape2D:
		original_radius = drag_shape.shape.radius
	elif drag_shape.shape is RectangleShape2D:
		original_rect_size = drag_shape.shape.size

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_start_drag()
		else:
			_end_drag()

func _process(_delta):
	if is_dragging:
		global_position = get_global_mouse_position() + drag_offset

func _start_drag():
	is_dragging = true
	drag_offset = global_position - get_global_mouse_position()

	# scale sprite
	sprite.scale = drag_scale

	# scale collision
	_apply_collision_scale(drag_scale)

func _end_drag():
	is_dragging = false

	sprite.scale = normal_scale
	_apply_collision_scale(normal_scale)

	_return_to_start()

func _return_to_start():
	global_position = start_position

func _apply_collision_scale(target_scale: Vector2):
	if drag_shape.shape is CircleShape2D:
		drag_shape.shape.radius = original_radius * target_scale.x
	elif drag_shape.shape is RectangleShape2D:
		drag_shape.shape.size = original_rect_size * target_scale
