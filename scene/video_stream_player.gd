extends VideoStreamPlayer

@onready var pause_btn = get_node("../Area2D/Button")
@onready var tilemap = get_node("../TileMapLayer")
# Ensure this name matches what you renamed the node to in the Scene Tree!
@onready var target_node = get_node("../Node2D") 

func _ready():
	finished.connect(_on_finished)
	pause_btn.hide()
	if target_node:
		target_node.hide() # Starts hidden

func _on_finished():
	play()

func _on_button_pressed() -> void:
	paused = !paused
	pause_btn.text = "Play" if paused else "Pause"
	
	var chest_pos = Vector2i(62, 20)
	
	if paused:
		# 1. Open Chest: Source 4, Atlas (0,0)
		tilemap.set_cell(chest_pos, 4, Vector2i(0, 0))
		# 2. Show the Target
		if target_node:
			target_node.show()
	else:
		# 1. Close Chest: Source 3, Atlas (0,0)
		tilemap.set_cell(chest_pos, 3, Vector2i(0, 0))
		# 2. Hide the Target
		if target_node:
			target_node.hide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player":
		pause_btn.show() # Show button when player is near

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "player":
		pause_btn.hide() # Hide button when player leaves
		
		
func _on_checkpoint_body_entered(body: Node2D) -> void:
	# This checks if the 'player' node entered the invisible area
	if body.name == "player":
		# Update the path below to your actual main menu scene file
		get_tree().change_scene_to_file("res://main_menu.tscn")
