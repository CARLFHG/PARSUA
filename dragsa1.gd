extends Area2D

var dragging = false
var original_pos: Vector2
var original_scale: Vector2

func _ready():
	original_pos = position
	original_scale = scale
	input_pickable = true # Must be true to detect clicks

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_start_dragging()
		else:
			_stop_dragging()

func _process(_delta):
	if dragging:
		global_position = get_global_mouse_position()

func _start_dragging():
	dragging = true
	# Enlarge when picked up
	var tween = create_tween()
	tween.tween_property(self, "scale", original_scale * 1.5, 0.1).set_trans(Tween.TRANS_BACK)

func _stop_dragging():
	dragging = false
	
	# Check for impact with the other element
	var targets = get_overlapping_areas()
	for target in targets:
		if target.has_method("take_damage"):
			target.take_damage()
	
	# Return to original position AND original scale
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "position", original_pos, 0.5).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", original_scale, 0.3)
