extends RigidBody3D

@export var time_til_delete :float= 10
@export var start_rotation : float= 20
@export var start_velocity : Vector3 =  Vector3.ZERO
@export var death_speed : float = 1.5

var can_damage = true
var can_trigger = true

var force_applied = false
var timer_started = false
var last_force = 0
var time = 0
var is_dead = false

@onready var original_gravity_scale = gravity_scale

func _ready():
	$AnimationPlayer.play("idle")
	sleeping = true
	gravity_scale = 0
	
func _physics_process(delta):
	$RayCast3D.global_position = global_position
	
	if get_angular_velocity().z != last_force:
		last_force = get_angular_velocity().z
		time = 0
		can_damage = true
		
	elif get_angular_velocity().z == last_force:
		time += delta
		can_damage = false
	
	if abs(get_angular_velocity().z) > death_speed || !$RayCast3D.is_colliding():
		can_damage = true
	else:
		can_damage = false
	
	if time > time_til_delete && !can_trigger && $RayCast3D.is_colliding():
		if !is_dead:
			is_dead = true
			$AnimationPlayer.play("death")
	
	
func entered_trigger_zone(body):
	if body.has_method("player") && can_trigger:
		sleeping = false
		can_trigger = false
		gravity_scale =  original_gravity_scale
		apply_central_impulse(start_velocity)
		apply_torque(Vector3(0,0,start_rotation))

func death():
	queue_free()

func delete_player(body):
	if body.has_method("player") && can_damage:
		body.on_dead()


