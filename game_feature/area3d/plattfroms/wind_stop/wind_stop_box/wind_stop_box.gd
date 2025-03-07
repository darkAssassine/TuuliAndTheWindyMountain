extends CharacterBody3D
class_name StopWindBox


@export var slow : float = 5
@export var speed : float = 3
@export var gravity : float = 14
@export var freeze_duration : float = 5
@export var freeze_timer : Timer

var is_freezed : bool= false
@onready var top_right = $TopRight.position
@onready var bottom_left = $BottomLeft.position


func _ready():
	freeze_timer.wait_time = freeze_duration

func _physics_process(delta):
	
	top_right =  $TopRight.global_position
	bottom_left = $BottomLeft.global_position
	
	if !is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0
		
	if velocity.x >0:
		velocity.x = lerpf(velocity.x,0, slow * delta)
	if velocity.x < 0:
		velocity.x = -lerpf(abs(velocity.x),0, slow * delta)
	
	if velocity.x < 0.1 && velocity.x> -0.1:
		velocity.x = 0
		
	if !is_freezed:
		velocity.x =0
		$MeshInstance.visible = true
		$MeshInstance2.visible = false
		
	else:
		$MeshInstance.visible = false
		$MeshInstance2.visible = true

	move_and_slide()



func player_entered(body):
	if body.has_method("player") && is_freezed:
		velocity.x = body.velocity.x + speed * body.last_direction
		

func move_able_box():
	pass






func _on_freeze_timer_timeout():
	is_freezed = false
	pass
