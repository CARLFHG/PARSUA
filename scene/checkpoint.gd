extends Area2D

# This allows you to pick the level file from the Inspector
@export_file("*.tscn") var next_level_path: String

func _ready():
	# This ensures the script is listening for the player
	# (You can also connect this via the Node Tab)
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	# Debug message to see what is hitting the teleport
	print("Body entered: ", body.name)
	
	# 'is CharacterBody2D' is safer than checking for "playerv2"
	if body is CharacterBody2D: 
		print("Next level triggered!")
		if next_level_path != "":
			get_tree().change_scene_to_file(next_level_path)
		else:
			print("Error: No level path selected in the Inspector!")
