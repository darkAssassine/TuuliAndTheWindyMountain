extends AudioStreamPlayer

@export var current_song: AudioStream
@export var song_c : AudioStream
var song_b : AudioStream



func _ready():
	set_stream(current_song)
	play()
	
func _on_finished():
	current_song = song_c
	set_stream(current_song)
	play()






func change_song(area):
	song_b = area.song
	if song_b == stream:
		set_stream(current_song)
		play()
		area.animation_player.play("red")
	else:
		set_stream(song_b)
		play()
		area.animation_player.play("blue")
		
