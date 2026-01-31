extends Area2D

@export var damage := 10
@export var damage_cooldown := 0.2

var dragging := false
var original_pos := Vector2.ZERO
var damage_timer := 0.0

func _ready():
	original_pos = position 
	$VideoStreamPlayer.hide()
	$VideoStreamPlayer.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _process(delta):
	if dragging:
		global_position = get_global_mouse_position()
		
		if not $VideoStreamPlayer.is_playing():
			$VideoStreamPlayer.show()
			$VideoStreamPlayer.play()
			if has_node("Sprite2D"): $Sprite2D.hide()
		
		damage_timer -= delta
		if damage_timer <= 0:
			deal_damage()
			damage_timer = damage_cooldown
	else:
		if $VideoStreamPlayer.is_playing():
			$VideoStreamPlayer.stop()
			$VideoStreamPlayer.hide()
			if has_node("Sprite2D"): $Sprite2D.show()

func deal_damage():
	var targets = get_overlapping_areas()
	for area in targets:
		if area.get_parent().has_method("take_damage"):
			area.get_parent().take_damage(damage, Color.WHITE)

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			# If this is the HUD icon, spawn a copy
			if get_parent().name != "levelroot 4": 
				var spray_scene = load("res://scene/spray_agent.tscn") # Corrected path
				if spray_scene:
					var world_spray = spray_scene.instantiate()
					get_tree().current_scene.add_child(world_spray)
					world_spray.global_position = get_global_mouse_position()
					world_spray.dragging = true
			else:
				dragging = true

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not event.pressed and dragging:
			dragging = false
			# Only delete the world-copy, keep the HUD icon!
			if get_parent().name == "levelroot 4":
				queue_free()
