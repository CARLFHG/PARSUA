extends Control

# UI Elements
@onready var start_button = $start
@onready var exit_button = $exit
@onready var option_button = $option
@onready var options = $Options

# Media Elements
@onready var bg_video = $VideoStreamPlayer      # Background menu video
@onready var cutscene_player = $cutsceneplayer  # The 40-second intro cutscene
@onready var background_music = $AudioStreamPlayer2D

func _ready():
	# 1. Reset UI State
	start_button.show()
	exit_button.show()
	option_button.show()
	options.hide()
	
	# 2. Start Background Video and Music
	bg_video.show()
	bg_video.play()
	background_music.play()
	
	# 3. Prepare Cutscene (Keep it hidden)
	cutscene_player.hide()
	cutscene_player.stop()

func _on_start_pressed() -> void:
	# 1. Stop everything else
	background_music.stop()
	bg_video.stop()
	bg_video.hide()
	
	# 2. Hide Menu UI
	start_button.hide()
	exit_button.hide()
	option_button.hide()
	
	# 3. Show and Play the Cutscene
	cutscene_player.show()
	cutscene_player.play()

# Connect the 'finished' signal of cutscene_player to this function
func _on_cutsceneplayer_finished() -> void:
	get_tree().change_scene_to_file("res://scene/levelroot1.tscn")

# --- UI Logic ---
func _on_exit_pressed():
	get_tree().quit()

func _on_button_2_pressed() -> void:
	start_button.hide()
	exit_button.hide()
	option_button.hide()
	options.show()

func _on_back_options_pressed() -> void:
	_ready()
