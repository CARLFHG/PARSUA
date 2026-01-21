extends Control

@onready var main_buttons: VBoxContainer = $MainButtons
@onready var options: Panel = $Options

func _on_exit_pressed():
	get_tree().quit() #CLOSE THE GAME

func _ready():
	main_buttons.visible= true #PARA VISIBLE SA MAIN MENU
	options.visible= false #PARA DI MUNA MAG SHOW


func _on_button_2_pressed() -> void:
	print("Settings pressed")
	main_buttons.visible=false #PARA MAWALA UNG MAIN BUTTONS
	options.visible=true #PARA MAG POP UP OPTIONS
	
 


func _on_back_options_pressed() -> void:
	_ready()
