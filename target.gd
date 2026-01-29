extends StaticBody2D

# Use @onready so the script waits for the ProgressBar to exist
@onready var health_bar = $ProgressBar
@onready var sprite = $Sprite2D

var health = 100

func _ready():
	if health_bar:
		health_bar.value = health

func take_damage(amount):
	health -= amount
	if health_bar:
		health_bar.value = health
	
	# Flash White Effect
	sprite.modulate = Color(10, 10, 10) 
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color(1, 1, 1)
	
	# Change frame as health drops
	if health < 50:
		sprite.frame = 1
	
	if health <= 0:
		# Instead of deleting it, just hide it so you can use it again!
		hide() 
		health = 100 # Reset health for next time
		if health_bar:
			health_bar.value = 100
