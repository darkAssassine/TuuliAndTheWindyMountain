extends Area3D

var pos

var can_trigger = true

func _ready():
	pos = $Node3D.global_position

func body_entered(body):
	if body.has_method("player") && can_trigger: 
		if body.respawn_position != pos:
			can_trigger = false
			body.respawn_position = Vector3(pos.x, pos.y,0)
			$AudioStreamPlayer.play()
			
