extends Area2D

@export var damage := 10
@export var damage_cooldown := 0.2
@onready var action_sound: AudioStreamPlayer2D = $ActionSound

var dragging := false
var original_pos := Vector2.ZERO
var damage_timer := 0.0

func _ready():
	original_pos = position 
	$VideoStreamPlayer.hide()
	$VideoStreamPlayer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	# Snap to mouse immediately if spawned as a clone
	if dragging:
		global_position = get_global_mouse_position()

func _process(delta):
	if dragging:
		global_position = get_global_mouse_position()
		
		# PLAY SOUND IMMEDIATELY WHEN DRAGGING
		if not action_sound.playing:
			action_sound.play()
		
		# Handle the Video Player
		if not $VideoStreamPlayer.is_playing():
			$VideoStreamPlayer.show()
			$VideoStreamPlayer.play()
			if has_node("Sprite2D"): $Sprite2D.hide()
		
		# Reset rock hitsound if we move away while dragging
		apply_damage_logic()
		
		damage_timer -= delta
		if damage_timer <= 0:
			deal_damage()
			damage_timer = damage_cooldown
	else:
		# STOP ALL SOUNDS AND VIDEO ON RELEASE
		stop_all_sounds() 
		if $VideoStreamPlayer.is_playing():
			$VideoStreamPlayer.stop()
			$VideoStreamPlayer.hide()
			if has_node("Sprite2D"): $Sprite2D.show()

func apply_damage_logic():
	var targets = get_overlapping_areas()
	# Only manage the rock's internal hitsound here
	if targets.size() == 0:
		# Use Scene Tree to find the rock and stop its specific sound
		var rock = get_tree().current_scene.find_child("rock", true, false)
		if rock and rock.has_node("hitsound"):
			rock.get_node("hitsound").stop()

func stop_all_sounds():
	if action_sound.playing:
		action_sound.stop()
	# Stop the rock's sound specifically
	var rock = get_tree().current_scene.find_child("rock", true, false)
	if rock and rock.has_node("hitsound"):
		rock.get_node("hitsound").stop()

func deal_damage():
	var targets = get_overlapping_areas()
	for area in targets:
		if area.get_parent().has_method("take_damage"):
			area.get_parent().take_damage(damage, Color.WHITE)

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if "levelroot 4" not in get_parent().name: 
				var spray_scene = load("res://scene/spray_agent.tscn")
				var world_spray = spray_scene.instantiate()
				world_spray.dragging = true
				get_tree().current_scene.add_child(world_spray)
				world_spray.global_position = get_global_mouse_position()
			else:
				dragging = true

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		# FIXED INDENTATION: Must be pushed right with a TAB
		if not event.pressed and dragging:
			stop_all_sounds() 
			dragging = false
			if "levelroot 4" not in get_parent().name:
				queue_free()
