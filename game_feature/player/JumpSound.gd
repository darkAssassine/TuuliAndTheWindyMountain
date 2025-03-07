extends AudioStreamPlayer

@export var jump_1 : AudioStream
@export var jump_2 : AudioStream
@export var jump_3 : AudioStream

func play_sound():
	var i = randi_range(1,3)
	match  i:
		1:
			set_stream(jump_1)
			play()
		2:
			set_stream(jump_2)
			play()
		3:
			set_stream(jump_3)
			play()
