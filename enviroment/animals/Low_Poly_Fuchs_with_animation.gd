extends Node3D

func _physics_process(delta):
	if !$AnimationPlayer.is_playing():
		$AnimationPlayer.play("Idle Animation")

func set_animatio(animation:String):
	#$AnimationPlayer.play(animation)
	pass
