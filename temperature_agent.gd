extends Area2D

@export var damage := 15
@export var damage_cooldown := 0.2
@export var flash_color := Color.RED # For the red flicker effect

var dragging := false
var damage_timer := 0.0
var original_pos := Vector2.ZERO

func _ready():
	original_pos = position
	# Ensure the Area2D is ready to detect inputs

func _process(delta):
	if dragging:
		# Follow the mouse
		global_position = get_global_mouse_position()
		
		# Damage logic
		damage_timer -= delta
		if damage_timer <= 0:
			apply_temperature_damage()
			damage_timer = damage_cooldown
	else:
		# If it's the HUD icon, stay put
		position = original_pos

func apply_temperature_damage():
	var targets = get_overlapping_areas()
	for area in targets:
		var rock = area.get_parent()
		if rock.has_method("take_damage"):
			# Send the RED color to the rock
			rock.take_damage(damage, flash_color)

# Make sure this function is connected to the 'input_event' signal in the Node tab!
func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			# Check if we are spawning from the HUD
			if get_parent().name != "levelroot 4": 
				var temp_scene = load("res://scene/temperature_agent.tscn")
				if temp_scene:
					var world_temp = temp_scene.instantiate()
					get_tree().current_scene.add_child(world_temp)
					world_temp.global_position = get_global_mouse_position()
					world_temp.dragging = true
			else:
				# If we are already in the world, just drag
				dragging = true
				z_index = 10

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not event.pressed and dragging:
			dragging = false
			# Delete the world copy on release, keep the HUD icon
			if get_parent().name == "levelroot 4":
				queue_free()
