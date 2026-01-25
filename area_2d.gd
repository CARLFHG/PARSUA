extends Area2D

@export var drag_scale_multiplier := 1.3
@export var damage := 10
@export var damage_cooldown := 0.3

@onready var sprite: Sprite2D = $Sprite2D

var dragging := false
var original_position: Vector2
var original_scale: Vector2
var grab_offset: Vector2
var can_damage := true

func _ready():
	input_pickable = true
	original_position = global_position
	original_scale = sprite.scale
	area_entered.connect(_on_area_entered)

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if _is_mouse_over():
				_start_drag(event.position)
		else:
			if dragging:
				_end_drag()

func _process(delta):
	if dragging:
		global_position = get_global_mouse_position() - grab_offset

func _start_drag(mouse_pos: Vector2):
	dragging = true
	grab_offset = mouse_pos - global_position
	sprite.scale = original_scale * drag_scale_multiplier

func _end_drag():
	dragging = false
	sprite.scale = original_scale
	global_position = original_position

func _on_area_entered(area: Area2D):
	if not dragging:
		return

	if not can_damage:
		return

	if area.has_method("take_damage"):
		can_damage = false
		area.take_damage(damage)
		await get_tree().create_timer(damage_cooldown).timeout
		can_damage = true

func _is_mouse_over() -> bool:
	var space = get_world_2d().direct_space_state
	var query := PhysicsPointQueryParameters2D.new()
	query.position = get_global_mouse_position()
	query.collide_with_areas = true

	for hit in space.intersect_point(query):
		if hit.collider == self:
			return true
	return false
