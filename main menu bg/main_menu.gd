extends Control

@onready var start_button = $start
@onready var exit_button = $exit
@onready var option_button = $option
@onready var options = $Options
# Match your lowercase name exactly
@onready var cutscene_player = $cutsceneplayer 

func _ready():
	# Make individual buttons visible
	start_button.visible = true
	exit_button.visible = true
	option_button.visible = true
	
	options.visible = false 

	# --- ADD THESE TWO LINES HERE ---
	cutscene_player.play()
	cutscene_player.stop()
	# --------------------------------
	
	# Make sure it stays hidden until we actually start
	cutscene_player.visible = false
func _on_start_pressed() -> void:
	# Show and play the cutscene
	cutscene_player.visible = true
	cutscene_player.play()
	
	# Optional: Hide buttons so they don't block the video if it's transparent
	start_button.visible = false
	exit_button.visible = false
	option_button.visible = false

# This triggers once the video ends
func _on_cutsceneplayer_finished() -> void:
	get_tree().change_scene_to_file("res://scene/levelroot1.tscn")

# --- Existing UI Logic ---
func _on_exit_pressed():
	get_tree().quit()

func _on_button_2_pressed() -> void:
	start_button.visible = false
	exit_button.visible = false
	option_button.visible = false
	options.visible = true

func _on_back_options_pressed() -> void:
	_ready()
