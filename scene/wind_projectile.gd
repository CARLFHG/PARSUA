extends Area2D

@export var speed := 50.0 # Faster than the wave!
@export var damage := 15
   # Lower damage but faster speed

func _ready():
	$AnimatedSprite2D.play("idling") # Replace "blowing" with your animation name

func _process(delta):
	# Move left to right
	position.x += speed * delta
	
	# Delete if off-screen
	if position.x > 1500: 
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	var rock = area.get_parent()
	
	if rock.has_method("take_damage"):
		# Wind uses a Cyan/Light Blue flicker
		rock.take_damage(damage, Color.CYAN)
		
		# Trigger the same shake function
		if rock.has_method("shake"):
			rock.shake()
			
		# Wind passes through or disappears? 
		# Delete the line below if you want the wind to hit multiple rocks!
		queue_free()
