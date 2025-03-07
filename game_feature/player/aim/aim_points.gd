extends CharacterBody3D



@export var speed : float = 4
var direction
var wind = Vector2.ZERO
var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity")
var cell_position
var velocity_vector


func _ready():
	
	direction = get_parent().DIRECTION

	velocity_vector = Vector2.from_angle(direction)
	velocity.y = -velocity_vector.y * speed 
	

func _process(delta):
	rotation.z = direction 
	velocity_vector = Vector2.from_angle(direction)
	velocity.x = velocity_vector.x * speed 


	
	velocity.y -= gravity * delta 
	
	
	
	
	velocity.x += wind.x * delta
	velocity.y += wind.y * delta
	
	
	move_and_slide()


