extends HSlider

var bus_audio_id

func _ready():
	bus_audio_id = AudioServer.get_bus_index(audio_bus_name)
	print

func _on_value_changed(value: float) -> void:
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(bus_audio_id, db)
	
	

@export var audio_bus_name: String
