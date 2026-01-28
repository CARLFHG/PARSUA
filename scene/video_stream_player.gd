extends VideoStreamPlayer

# Path must go UP to levelroot3, then into Area2D, then to Button
@onready var pause_btn = get_node("../Area2D/Button") 

func _ready():
	finished.connect(_on_finished)
	pause_btn.hide() # This will now work because the path is correct

func _on_finished():
	play()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player": 
		pause_btn.show()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "player":
		pause_btn.hide()

func _on_button_pressed() -> void:
	paused = !paused
	pause_btn.text = "Play" if paused else "Pause"
