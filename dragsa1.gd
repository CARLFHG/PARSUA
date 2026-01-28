extends Area2D

var dragging = false
var original_pos: Vector2
var original_scale: Vector2
var drag_offset = Vector2.ZERO # This variable removes the offset

func _ready():
	original_pos = position
	original_scale = scale
	input_pickable = true 
	monitoring = true 

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			# FIX: Calculate the distance between the center and the click point
			# This "locks" the item to your mouse exactly where you grabbed it.
			drag_offset = global_position - get_global_mouse_position()
			_start_dragging()
		else:
			_stop_dragging()

func _process(_delta):
	if dragging:
		# FIX: Apply the offset so it doesn't "jump" to the cursor center
		global_position = get_global_mouse_position() + drag_offset

func _start_dragging():
	dragging = true
	var tween = create_tween()
	tween.tween_property(self, "scale", original_scale * 1.5, 0.1).set_trans(Tween.TRANS_BACK)

func _stop_dragging():
	dragging = false
	
	# Damage Logic
	var targets = get_overlapping_bodies() 
	for target in targets:
		if target.has_method("take_damage"):
			target.take_damage(20)
	
	# Return Home
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "position", original_pos, 0.5).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", original_scale, 0.3)
