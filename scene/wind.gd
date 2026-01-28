extends Area2D

@export var drag_scale := 1.2
@export var damage := 10
@export var damage_cooldown := 0.2  # seconds between damage ticks

var original_position: Vector2
var original_scale: Vector2
var dragging := false
var drag_offset := Vector2.ZERO
var damage_timer := 0.0

func _ready():
	original_position = global_position
	original_scale = scale

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragging = true
			drag_offset = global_position - get_global_mouse_position()
			scale = original_scale * drag_scale
			z_index = 100
			damage_timer = 0.0
		else:
			dragging = false
			scale = original_scale
			global_position = original_position
			z_index = 0

func _process(delta):
	if not dragging:
		return

	global_position = get_global_mouse_position() + drag_offset

	damage_timer -= delta
	if damage_timer <= 0:
		# deal damage to all overlapping damageables
		for area in get_overlapping_areas():
			if area.has_method("take_damage"):
				area.take_damage(damage)
		damage_timer = damage_cooldown
