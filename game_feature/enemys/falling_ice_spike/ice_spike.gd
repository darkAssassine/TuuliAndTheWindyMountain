extends Area3D

@export var fall_speed : float = 9.8

var can_damage = true
var should_fall : bool = false
var can_fall: bool = false
var trigger = true

func _physics_process(delta):
	if should_fall && can_fall:
		fall_speed = fall_speed +fall_speed * delta  *2
		position.y -= fall_speed * delta
		
	if $RayCast3D.is_colliding():
		can_damage = false
		should_fall = false
		can_fall = false
	else:
	
		can_damage = true

	
func kill_player(body):
	if body.has_method("player") && can_damage:
		body.on_dead()

func spikes():
	should_fall = true

func trigger_fall(body):
	if body.has_method("player")&& trigger:
		trigger = false
		can_fall = true
		$Eiszapfen_Animation/AnimationPlayer.play("CylinderAction")


