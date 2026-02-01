extends Node2D

@onready var bg_player = $BackgroundPlayer
# Use this path if CanvasLayer2 is a child of level_sedimentation
@onready var cutscene_player = $CanvasLayer2/CutscenePlayer
@onready var action_button = $CanvasLayer/ActionButton
@onready var player = $playerv2
@onready var bg_music = $BackgroundMusic

var current_step = 1

var level_steps = {
	1: {"btn": "Inspect Rock", "bg": "res://videos/background/normal_waves_ogv.ogv", "cut": "res://videos/cutscenes/fast_waves_ogv.ogv"},
	2: {"btn": "Deposit", "bg": "res://videos/background/swaying_rocks_ogv.ogv", "cut": "res://videos/cutscenes/vid2_depositing_ogv.ogv"},
	3: {"btn": "Compaction", "bg": "res://videos/background/seaweed_swaying_ogv.ogv", "cut": "res://videos/cutscenes/vid4_compaction_ogv.ogv"},
	4: {"btn": "Cementation", "bg": "res://videos/background/cementation_bg_ogv.ogv", "cut": "res://videos/cutscenes/vid6_minerals_ogv.ogv"},
	5: {"btn": "Tectonic Uplift", "bg": "res://videos/background/uplift_bg_ogv.ogv", "cut": "res://videos/cutscenes/vid7_tectonic_ogv.ogv"}
}

func _ready():
	# 1. Verification to prevent 'Null Instance' crashes
	if not cutscene_player or not bg_music:
		print("ERROR: Check your Scene Tree names for BackgroundMusic and CutscenePlayer!")
		return

	# 2. Setup signals and music
	cutscene_player.finished.connect(_on_cutscene_finished)
	action_button.pressed.connect(_on_action_pressed)
	bg_music.play()
	
	# 3. Handle player UI and movement
	if player:
		player.set_process_input(false) # Stops agent spawning
		var player_hud = player.get_node_or_null("hud")
		if player_hud: player_hud.hide()
		
		var cam = player.get_node_or_null("Camera2D")
		if cam: cam.enabled = false

	# 4. Start the first stage
	update_stage()

func _on_action_pressed():
	action_button.disabled = true
	action_button.hide()
	
	# Duck the music volume so we can hear the cutscene
	bg_music.volume_db = -10 
	
	cutscene_player.stream = load(level_steps[current_step]["cut"])
	cutscene_player.show()
	cutscene_player.play()

func _on_cutscene_finished():
	cutscene_player.hide()
	bg_music.volume_db = 0 # Reset music volume
	
	current_step += 1
	if current_step > 5:
		get_tree().change_scene_to_file("res://scene/levelroot1.tscn")
	else:
		update_stage()
		action_button.show()
		action_button.disabled = false

func update_stage():
	# Set text and load background video
	action_button.text = level_steps[current_step]["btn"]
	bg_player.stream = load(level_steps[current_step]["bg"])
	bg_player.play()
