extends Marker3D

func _ready():
	$AnimationPlayer.play("fade")

func self_delete():
	queue_free()
	

