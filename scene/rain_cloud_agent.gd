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
	
	if dragging:
		global_position = get_global_mouse_position()

func _process(delta):
	if dragging:
		global_position = get_global_mouse_position()
		
		if action_sound and not action_sound.playing:
			action_sound.play()
		
		if $AnimatedSprite2D.animation != "raining":
			$AnimatedSprite2D.play("raining")
		
		apply_damage_logic()
		
		damage_timer -= delta
		if damage_timer <= 0:
			apply_rain_damage()
			damage_timer = damage_cooldown
	else:
		stop_all_sounds() 
		position = original_pos
		$AnimatedSprite2D.play("idle")

func apply_damage_logic():
	var targets = get_overlapping_areas()
	# If not hitting anything, make sure the rock hitsound stops
	if targets.size() == 0:
		_stop_rock_hitsound()

func stop_all_sounds():
	if action_sound and action_sound.playing:
		action_sound.stop()
	_stop_rock_hitsound()

# Helper function to find the rock regardless of exact name ("rock" vs "Target rock")
func _stop_rock_hitsound():
	# Updated to match your screenshot name "Target rock" or generic "rock"
	var rock = get_tree().current_scene.find_child("Target rock", true, false)
	if not rock:
		rock = get_tree().current_scene.find_child("rock", true, false)
		
	if rock:
		var hs = rock.get_node_or_null("hitsound")
		if hs and hs is AudioStreamPlayer2D and hs.playing:
			hs.stop()

func apply_rain_damage():
	var targets = get_overlapping_areas()
	for area in targets:
		# Check the area itself or its parent (the StaticBody2D)
		var target = area if area.has_method("take_damage") else area.get_parent()
		
		if target.has_method("take_damage"):
			# Pass the damage. Note: Ensure your Rock script's 
			# take_damage function can accept the flash_color argument!
			target.take_damage(damage) 

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
		if not event.pressed and dragging:
			stop_all_sounds()
			dragging = false
			if "levelroot 4" not in get_parent().name:
				queue_free()
