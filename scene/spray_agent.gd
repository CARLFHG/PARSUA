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

func _process(delta):
	if dragging:
		global_position = get_global_mouse_position()
		apply_damage_logic() # Trigger sound logic
		
		if not $VideoStreamPlayer.is_playing():
			$VideoStreamPlayer.show()
			$VideoStreamPlayer.play()
			if has_node("Sprite2D"): $Sprite2D.hide()
		
		damage_timer -= delta
		if damage_timer <= 0:
			deal_damage()
			damage_timer = damage_cooldown
	else:
		stop_all_sounds() # Stop sounds when not dragging
		if $VideoStreamPlayer.is_playing():
			$VideoStreamPlayer.stop()
			$VideoStreamPlayer.hide()
			if has_node("Sprite2D"): $Sprite2D.show()

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
	# Find the rock in the scene and force its hitsound to stop
	var targets = get_overlapping_areas()
	for area in targets:
		var rock = area.get_parent()
		if rock.has_node("hitsound"):
			rock.hitsound.stop()

func deal_damage():
	var targets = get_overlapping_areas()
	for area in targets:
		if area.get_parent().has_method("take_damage"):
			area.get_parent().take_damage(damage, Color.WHITE)

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if get_parent().name != "levelroot 4": 
				var spray_scene = load("res://scene/spray_agent.tscn")
				var world_spray = spray_scene.instantiate()
				get_tree().current_scene.add_child(world_spray)
				world_spray.global_position = get_global_mouse_position()
				world_spray.dragging = true
			else:
				dragging = true

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not event.pressed and dragging:
			stop_all_sounds() # Ensure silence on release
			dragging = false
			if get_parent().name == "levelroot 4":
				queue_free()
