extends Area2D

@export var speed := 150.0 
@export var damage := 15
var direction := 1 

@onready var sfx = $AudioStreamPlayer2D

func _ready():
	$AnimatedSprite2D.play("idling") 
	if sfx: sfx.play()
	# Clean up after 2 seconds to prevent memory leaks
	get_tree().create_timer(2.0).timeout.connect(clean_up)

func set_direction(dir):
	direction = dir
	$AnimatedSprite2D.flip_h = (dir == -1)

func _process(delta):
	position.x += (speed * direction) * delta
	# Automatic cleanup if it goes off screen
	if abs(position.x) > 2500: 
		clean_up()

# Replace _on_area_entered with this:
func _on_body_entered(body: Node2D) -> void:
	print("Wind touched something: ", body.name) # Debug print
	
	if body.has_method("take_damage"):
		print("SUCCESS: Rock detected!")
		body.take_damage(damage)
		clean_up() # Destroy projectile on hit

func clean_up():
	queue_free()

# Keep this just in case you use an Area2D on the rock instead
func _on_area_entered(area: Area2D) -> void:
	var rock = area.get_parent()
	if rock.has_method("take_damage"):
		rock.take_damage(damage)
		clean_up()
