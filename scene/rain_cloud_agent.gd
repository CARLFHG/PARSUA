extends Area2D

@export var damage := 12
@export var damage_cooldown := 0.2
@export var flash_color := Color.BLUE # Water damage flicker

var dragging := false
var damage_timer := 0.0
var original_pos := Vector2.ZERO

func _ready():
	original_pos = position
	# Start with the cloud just floating
	$AnimatedSprite2D.play("idle") 

func _process(delta):
	if dragging:
		# Cloud follows the mouse
		global_position = get_global_mouse_position()
		
		# Switch to raining animation
		if $AnimatedSprite2D.animation != "raining":
			$AnimatedSprite2D.play("raining")
		
		# Damage logic
		damage_timer -= delta
		if damage_timer <= 0:
			apply_rain_damage()
			damage_timer = damage_cooldown
	else:
		# Return to the HUD and stop the rain
		position = original_pos
		$AnimatedSprite2D.play("idle")

func apply_rain_damage():
	# Detection using the hitbox system
	var targets = get_overlapping_areas()
	for area in targets:
		var rock = area.get_parent()
		if rock.has_method("take_damage"):
			# Tells the rock to flicker BLUE
			rock.take_damage(damage, flash_color)

# MUST be connected in the Node tab!
func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			# Check if we are spawning a new one from the HUD
			if get_parent().name != "levelroot 4": 
				var cloud_scene = load("res://scene/rain_cloud_agent.tscn")
				var world_cloud = cloud_scene.instantiate()
				get_tree().current_scene.add_child(world_cloud)
				world_cloud.global_position = get_global_mouse_position()
				world_cloud.dragging = true
			else:
				dragging = true

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not event.pressed and dragging:
			dragging = false
			# Delete world copy on release, keep HUD icon
			if get_parent().name == "levelroot 4":
				queue_free()
