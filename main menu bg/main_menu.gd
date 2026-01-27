extends Control

@onready var start_button = $start
@onready var exit_button = $exit
@onready var option_button = $option
@onready var options = $Options

func _on_exit_pressed():
	get_tree().quit() #CLOSE THE GAME

func _ready():
	# Make individual buttons visible
	start_button.visible = true
	exit_button.visible = true
	option_button.visible = true
	
	options.visible = false # This one stays the same


func _on_button_2_pressed() -> void:
	print("Settings pressed")
	# Hide the individual buttons
	start_button.visible = false
	exit_button.visible = false
	option_button.visible = false
	
	# Show the options panel
	options.visible = true



func _on_back_options_pressed() -> void:
	_ready()


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/levelroot1.tscn")

	
