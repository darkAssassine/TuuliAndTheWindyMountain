extends Area3D

var can_damage = true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spikes():
	pass


func _on_body_entered(body):
	if body.has_method("player"):
		body.on_dead()
