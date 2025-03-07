extends Area3D

@export var sound  : AudioStream

func _ready():
	$AudioStreamPlayer.stream = sound

func _on_body_entered(body):
	if body.has_method("player"):
		$AudioStreamPlayer.play()

func _on_audio_stream_player_finished():
	$AudioStreamPlayer.play()

func _on_body_exited(body):
	if body.has_method("player"):
		$AudioStreamPlayer.stop()
