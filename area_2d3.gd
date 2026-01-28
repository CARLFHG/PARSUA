extends Area2D

@export var next_level_path: String = "res://scene/levelroot_3.tscn"

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	print("Body entered:", body.name)
	if body.name == "player":
		print("Next level triggered!")
		get_tree().change_scene_to_file(next_level_path)
