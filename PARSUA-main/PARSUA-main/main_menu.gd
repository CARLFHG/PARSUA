extends Control

@onready var main_buttons: VBoxContainer = $MainButtons
@onready var options: Panel = $Options

func _on_exit_pressed():
	get_tree().quit() #CLOSE THE GAME

func _ready():
	main_buttons.visible= true
	options.visible= false


func _on_button_2_pressed() -> void:
	print("Settings pressed")
	main_buttons.visible=false
	options.visible=true
	
 
