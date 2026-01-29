extends VideoStreamPlayer

# Correct paths: Up to levelroot3, then into Area2D or TileMapLayer
@onready var pause_btn = get_node("../Area2D/Button")
@onready var tilemap = get_node("../TileMapLayer")

var is_first_pause = true

func _ready():
	# Connect signal to loop the video
	finished.connect(_on_finished)
	# Hide button until player enters the trigger area
	pause_btn.hide()

func _on_finished():
	play()

# This function runs when you click the 'pause' button

func _on_button_pressed() -> void:
	paused = !paused
	pause_btn.text = "Play" if paused else "Pause"
	
	var chest_pos = Vector2i(62, 20)
	
	if paused:
		# Open Chest: Source 4, Atlas (0, 0)
		tilemap.set_cell(chest_pos, 4, Vector2i(0, 0))
	else:
		# Closed Chest: Source 3, Atlas (0, 0) <--- FIXED SOURCE ID
		tilemap.set_cell(chest_pos, 3, Vector2i(0, 0))

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player":
		pause_btn.show() # This makes it visible

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "player":
		pause_btn.hide() # This hides it when you walk away
