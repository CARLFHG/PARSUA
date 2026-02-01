extends Area2D

@export var speed := 150.0 
@export var damage := 15
var direction := 1 

@onready var sfx = $AudioStreamPlayer2D

func _ready():
	$AnimatedSprite2D.play("idling") 
	if sfx: sfx.play()
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
		rock.take_damage(damage, Color.CYAN)
		if rock.has_method("shake"):
			rock.shake()
		clean_up()

func clean_up():
	if sfx and sfx.playing:
		sfx.stop()
	queue_free()
