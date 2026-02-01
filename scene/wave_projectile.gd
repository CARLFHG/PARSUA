extends Area2D

@export var speed := 100.0 
@export var damage := 100
var direction := 1 

@onready var sfx = $AudioStreamPlayer2D
@onready var sprite = $AnimatedSprite2D

func _ready():
	if sprite:
		sprite.play("idling") 
	
	if sfx: 
		sfx.play()
	
	# Self-destruct after 2 seconds
	get_tree().create_timer(2.0).timeout.connect(clean_up)

func set_direction(dir):
	direction = dir
	if sprite:
		sprite.flip_h = (dir == -1)

func _process(delta):
	position.x += (speed * direction) * delta

func _on_area_entered(area: Area2D) -> void:
	# Try the area itself, then try its parent
	_handle_impact(area)
	_handle_impact(area.get_parent())

func _on_body_entered(body: Node2D) -> void:
	_handle_impact(body)

func _handle_impact(target: Node):
	if target.has_method("take_damage"):
		target.take_damage(damage, Color.BLUE)
		if target.has_method("shake"):
			target.shake()
		clean_up()

func clean_up():
	# If sound is still playing, we might want to hide the wave 
	# and wait for the sound to finish before queue_free()
	if sfx and sfx.playing:
		set_deferred("monitoring", false) # Stop checking collisions
		hide() # Make it invisible
		sfx.finished.connect(queue_free) # Delete ONLY after sound finishes
	else:
		queue_free()
