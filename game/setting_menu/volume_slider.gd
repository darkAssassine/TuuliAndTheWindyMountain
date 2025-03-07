extends HSlider

@export var bus_name : String

var bus_index : int
var ready_over : bool = false

func _ready():
	bus_index = AudioServer.get_bus_index(bus_name)
	value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))
	ready_over = true
	
func _on_value_changed(value):
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))

	if ready_over && (bus_name == "sfx"|| bus_name == "Master"):
		$AudioStreamPlayer.play()


