extends Area2D

@export var speed := 100.0 
@export var damage := 100
var direction := 1 

@onready var sfx = $AudioStreamPlayer2D # Ensure this matches your node name!

func _ready():
	$AnimatedSprite2D.play("idling") 
	# Play sound as soon as it's born
	if sfx: sfx.play()
	
	# Self-destruct after 2 seconds
	get_tree().create_timer(2.0).timeout.connect(clean_up)

func set_direction(dir):
	direction = dir
	$AnimatedSprite2D.flip_h = (dir == -1)

func _process(delta):
	position.x += (speed * direction) * delta
	if abs(position.x) > 2500: 
		clean_up()

func _on_area_entered(area: Area2D) -> void:
	var rock = area.get_parent()
	if rock.has_method("take_damage"):
		rock.take_damage(damage, Color.BLUE)
		if rock.has_method("shake"):
			rock.shake()
		clean_up()

func clean_up():
	# Stop the sound BEFORE deleting the node
	if sfx and sfx.playing:
		sfx.stop()
	queue_free()
