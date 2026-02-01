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
	# Snap to mouse immediately if spawned as a clone
	if dragging:
		global_position = get_global_mouse_position()

func _process(delta):
	if dragging:
		global_position = get_global_mouse_position()
		
		# PLAY SOUND IMMEDIATELY WHEN DRAGGING
		if not action_sound.playing:
			action_sound.play()
		
		if $AnimatedSprite2D.animation != "raining":
			$AnimatedSprite2D.play("raining")
		
		# Handle rock sound reset if moving away
		apply_damage_logic()
		
		damage_timer -= delta
		if damage_timer <= 0:
			apply_rain_damage()
			damage_timer = damage_cooldown
	else:
		# STOP SOUND WHEN RELEASED
		stop_all_sounds() 
		position = original_pos
		$AnimatedSprite2D.play("idle")

func apply_damage_logic():
	var targets = get_overlapping_areas()
	# If we are dragging but NOT over the rock, stop the rock's hitsound
	if targets.size() == 0:
		# We use the Scene Tree to find the rock and stop its sound
		var rock = get_tree().current_scene.find_child("rock", true, false)
		if rock and rock.has_node("hitsound"):
			rock.get_node("hitsound").stop()

func stop_all_sounds():
	if action_sound.playing:
		action_sound.stop()
	# Force rock sound to stop
	var rock = get_tree().current_scene.find_child("rock", true, false)
	if rock and rock.has_node("hitsound"):
		rock.get_node("hitsound").stop()

func apply_rain_damage():
	var targets = get_overlapping_areas()
	for area in targets:
		var rock = area.get_parent()
		if rock.has_method("take_damage"):
			rock.take_damage(damage, flash_color)

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if "levelroot 4" not in get_parent().name:
				var cloud_scene = load("res://scene/rain_cloud_agent.tscn")
				var world_cloud = cloud_scene.instantiate()
				world_cloud.dragging = true
				get_tree().current_scene.add_child(world_cloud)
				world_cloud.global_position = get_global_mouse_position()
			else:
				dragging = true

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		# FIXED INDENTATION: These lines must be pushed right with a TAB
		if not event.pressed and dragging:
			stop_all_sounds()
			dragging = false
			if "levelroot 4" not in get_parent().name:
				queue_free()
