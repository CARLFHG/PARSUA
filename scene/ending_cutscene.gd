extends Control

@onready var video_player = $VideoStreamPlayer

func _ready():
	# Connect the finished signal so the game knows when the video ends
	video_player.finished.connect(_on_video_finished)
	# Start the video
	video_player.play()

func _on_video_finished():
	# Replace this path with the actual path to your Main Menu scene
	get_tree().change_scene_to_file("res://scene/main_menu.tscn")
