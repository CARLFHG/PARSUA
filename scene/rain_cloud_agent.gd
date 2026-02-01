extends Area2D

@export var damage := 12
@export var damage_cooldown := 0.2
@export var flash_color := Color.BLUE
@onready var action_sound: AudioStreamPlayer2D = $ActionSound

var dragging := false
var damage_timer := 0.0
var original_pos := Vector2.ZERO

func _ready():
	original_pos = position
	$AnimatedSprite2D.play("idle")

func _process(delta):
	if dragging:
		global_position = get_global_mouse_position()
		apply_damage_logic() # Handle rain sounds
		
		if $AnimatedSprite2D.animation != "raining":
			$AnimatedSprite2D.play("raining")
		
		damage_timer -= delta
		if damage_timer <= 0:
			apply_rain_damage()
			damage_timer = damage_cooldown
	else:
		stop_all_sounds() # Reset cloud and sound
		position = original_pos
		$AnimatedSprite2D.play("idle")

# Inside spray_agent.gd and rain_cloud_agent.gd
func apply_damage_logic():
	var targets = get_overlapping_areas()
	if targets.size() > 0:
		if not action_sound.playing:
			action_sound.play() 
	else:
		# When you move the mouse AWAY from the rock, we stop the sound
		if action_sound.playing:
			action_sound.stop()
		
		# Reset the rock sound so it's ready for the next hit
		for area in targets:
			var rock = area.get_parent()
			if rock.has_node("hitsound"):
				rock.hitsound.stop()

func stop_all_sounds():
	if action_sound.playing:
		action_sound.stop()
	# Check overlapping areas to find the rock specifically
	var targets = get_overlapping_areas()
	for area in targets:
		var rock = area.get_parent()
		if rock.has_node("hitsound"):
			rock.hitsound.stop()

func apply_rain_damage():
	var targets = get_overlapping_areas()
	for area in targets:
		var rock = area.get_parent()
		if rock.has_method("take_damage"):
			rock.take_damage(damage, flash_color)

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
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
			stop_all_sounds()
			dragging = false
			if get_parent().name == "levelroot 4":
				queue_free()
