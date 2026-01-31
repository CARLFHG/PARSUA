extends Area2D

@export var speed := 30.0
@export var damage := 100



func _ready():
	$AnimatedSprite2D.play("idling") # Replace "blowing" with your animation name

func _process(delta):
	# Move automatically from left to right
	position.x += speed * delta
	
	# Delete the wave if it goes off-screen to save memory
	if position.x > 1500: 
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	# Look for the rock's 'hitbox'
	var rock = area.get_parent()
	
	if rock.has_method("take_damage"):
		# Deal damage and turn the rock BLUE
		rock.take_damage(damage, Color.BLUE)
		
		# Trigger the shake effect
		if rock.has_method("shake"):
			rock.shake()
		
		# Delete the wave after it hits the rock
		queue_free()
