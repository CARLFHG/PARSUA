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
		if action_sound and not action_sound.playing:
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
		# STOP ONLY SPRAY SFX AND VIDEO ON RELEASE
		stop_all_sounds() 
		if $VideoStreamPlayer.is_playing():
			$VideoStreamPlayer.stop()
			$VideoStreamPlayer.hide()
			if has_node("Sprite2D"): $Sprite2D.show()

func apply_damage_logic():
	var targets = get_overlapping_areas()
	# Only manage the rock's internal hitsound here
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
func deal_damage():
	var targets = get_overlapping_areas()
	for area in targets:
		if area.get_parent().has_method("take_damage"):
			area.get_parent().take_damage(damage, Color.WHITE)

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			# Added "levelroot2" and "levelroot4" to the list of 'dragging only' levels
			if "levelroot2" in get_parent().name or "levelroot4" in get_parent().name:
				dragging = true
			else:
				# This part spawns the clones - only for level 1
				var spray_scene = load("res://scene/spray_agent.tscn")
				var world_spray = spray_scene.instantiate()
				world_spray.dragging = true
				get_tree().current_scene.add_child(world_spray)
				world_spray.global_position = get_global_mouse_position()

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not event.pressed and dragging:
			stop_all_sounds()
			dragging = false
			# If we are in level 2 or 4, DO NOT delete the can (queue_free)
			if "levelroot2" in get_parent().name or "levelroot4" in get_parent().name:
				position = original_pos # Snap back to the UI shelf
			else:
				queue_free() # Only delete clones in level 1
