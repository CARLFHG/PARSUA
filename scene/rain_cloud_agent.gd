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
		if action_sound and not action_sound.playing:
			action_sound.play()
		
		if $AnimatedSprite2D.animation != "raining":
			$AnimatedSprite2D.play("raining")
		
		# Logic to handle rock hitsound reset
		apply_damage_logic()
		
		damage_timer -= delta
		if damage_timer <= 0:
			apply_rain_damage()
			damage_timer = damage_cooldown
	else:
		# STOP ONLY CLOUD SFX ON RELEASE
		stop_all_sounds() 
		position = original_pos
		$AnimatedSprite2D.play("idle")

func apply_damage_logic():
	var targets = get_overlapping_areas()
	# Stop the rock's sound if we move the cloud away while dragging
	if targets.size() == 0:
		var rock = get_tree().current_scene.find_child("rock", true, false)
		if rock and rock.has_node("hitsound"):
			var hs = rock.get_node("hitsound")
			if hs.playing:
				hs.stop()

func stop_all_sounds():
	# 1. Only stop the specific sound attached to THIS agent
	if action_sound and action_sound.playing:
		action_sound.stop()
	
	# 2. Use a safer way to find and stop the rock sound
	var rock = get_tree().current_scene.find_child("rock", true, false)
	if rock:
		var hs = rock.get_node_or_null("hitsound")
		if hs and hs is AudioStreamPlayer2D and hs.playing:
			hs.stop()

func apply_rain_damage():
	var targets = get_overlapping_areas()
	for area in targets:
		var rock = area.get_parent()
		if rock.has_method("take_damage"):
			rock.take_damage(damage, flash_color)

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			# Logic for cloning or dragging depending on level
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
		# FIXED INDENTATION: Corrected the parser error seen in your screenshot
		if not event.pressed and dragging:
			stop_all_sounds()
			dragging = false
			if "levelroot 4" not in get_parent().name:
				queue_free()
