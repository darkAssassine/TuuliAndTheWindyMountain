extends PathFollow3D
class_name wind_stop_box
@export var speed : float = 3
@export var goes_plattform_up : bool = false

var player = 0

func _physics_process(delta):
	if progress_ratio < 0.1 && speed<0:
		speed = abs(speed)
	if progress_ratio > 0.9 && speed >0:
		speed = abs(speed) *-1
	
	progress += speed * delta
		
	if player:
		player.plattfrom_speed = speed
		
func player_entered(body):
	
	if body.has_method("player") && !goes_plattform_up:
	
		player = body
		


func player_exited(body):
	if body.has_method("player"):
		
		player.plattfrom_speed = 0
		player = 0
		body.plattfrom_speed = 0

func move_able_box():
	pass
