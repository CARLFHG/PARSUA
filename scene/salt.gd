extends Area2D

@export var drag_scale := 1.2
@export var damage := 10
@export var damage_cooldown := 0.2  # damage every 0.2s

var original_position: Vector2
var original_scale: Vector2
var dragging := false
var drag_offset := Vector2.ZERO
var damage_timer := 0.0

func _ready():
	original_position = position
	original_scale = scale

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragging = true
			# mouse pos relative to parent
			var mouse_pos_parent = get_parent().to_local(get_viewport().get_mouse_position())
			drag_offset = position - mouse_pos_parent
			scale = original_scale * drag_scale
			z_index = 100
			damage_timer = 0.0
		else:
			dragging = false
			scale = original_scale
			position = original_position
			z_index = 0

func _process(delta):
	if not dragging:
		return

	# move relative to parent
	var mouse_pos_parent = get_parent().to_local(get_viewport().get_mouse_position())
	position = mouse_pos_parent + drag_offset

	# hover damage
	damage_timer -= delta
	if damage_timer <= 0:
		for area in get_overlapping_areas():
			if area.has_method("take_damage"):
				area.take_damage(damage)
		damage_timer = damage_cooldown
