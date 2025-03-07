extends  Control

var anim_playing = false

func _physics_process(delta):
	if visible && !anim_playing:
		$AnimationPlayer.play("fade_in")
		anim_playing = true
	if !visible:
		anim_playing = false
