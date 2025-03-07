extends GPUParticles3D


@export var is_enabled : bool = true
# Called when the node enters the scene tree for the first time.
func _ready():
	emitting = is_enabled


func enable():
	emitting = true

func disable():
	emitting = false

