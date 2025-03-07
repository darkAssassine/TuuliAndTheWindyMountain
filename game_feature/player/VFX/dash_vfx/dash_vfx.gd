extends Marker3D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("fade")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func flip_sprites():
	$Ghost.flip_h = true

	
func delte_self():
	queue_free()
