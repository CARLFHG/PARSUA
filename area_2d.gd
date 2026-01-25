extends Area2D

@export var drag_scale_multiplier := 1.3
@export var damage := 25  # damage applied on drop

@onready var sprite: Sprite2D = $Sprite2D

var dragging := false
var original_position: Vector2
var original_scale: Vector2
var grab_offset: Vector2
var hovered_target: Area2D = null

func _ready():
	input_pickable = true
	original_position = global_position
	original_scale = sprite.scale

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if is_mouse_over():
				start_drag(event.position)
		else:
			if dragging:
				end_drag()

func _process(delta):
	if dragging:
		global_position = get_global_mouse_position() - grab_offset
		_update_hovered_target()

func start_drag(mouse_pos: Vector2):
	dragging = true
	grab_offset = mouse_pos - global_position
	sprite.scale = original_scale * drag_scale_multiplier
	hovered_target = null

func end_drag():
	dragging = false
	sprite.scale = original_scale
	if hovered_target != null:
		hovered_target.take_damage(damage)
		print("Damage inflicted to ", hovered_target)
	global_position = original_position
	hovered_target = null

func is_mouse_over() -> bool:
	var space_state = get_world_2d().direct_space_state
	var query := PhysicsPointQueryParameters2D.new()
	query.position = get_global_mouse_position()
	query.collide_with_areas = true
	var results = space_state.intersect_point(query)
	for result in results:
		if result.collider == self:
			return true
	return false

func _update_hovered_target():
	var space_state = get_world_2d().direct_space_state
	var query := PhysicsPointQueryParameters2D.new()
	query.position = global_position
	query.collide_with_areas = true
	var results = space_state.intersect_point(query)
	hovered_target = null
	for result in results:
		if result.collider.has_method("take_damage"):
			hovered_target = result.collider
			return
