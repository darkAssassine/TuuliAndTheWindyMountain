extends CharacterBody3D


@export var speed : float = 4
var direction
var wind = Vector2.ZERO
var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity")
var cell_position
var velocity_vector
var b_rotation : float



func _ready():
	
	direction = get_parent().DIRECTION
	rotation.z = -direction
	velocity_vector = Vector2.from_angle(direction)
	velocity.y = -velocity_vector.y * speed 
	$AnimationPlayer.play("travel")
	$DestroyTileAnimation.visible = false
func _physics_process(delta):
	
	velocity_vector = Vector2.from_angle(direction)
	velocity.x = velocity_vector.x * speed 
	
	
			

	#velocity.y -= gravity * delta 
	
	

	
	#velocity.x += wind.x * delta
	#velocity.y += wind.y * delta

	move_and_slide()

func enemy_entered(body):
	if body.has_method("enemy") :
		body.current_state = body.state.freeze
		body.anim_player.play("freeze")
	
	if body.has_method("destroy_tile") :
		body.destroy_tile(Vector3(global_position.x,global_position.y,0) )
		$DestroyTileAnimation.visible = true
		$DestroyTileAnimation.play("default")
	if body.has_method("move_able_box"):
		body.is_freezed = true
		body.freeze_timer.start()
	if !body.has_method("player"):
		$AnimationPlayer.play("burst")
		speed = 0
		velocity = Vector3.ZERO
		pass

func bullet():
	queue_free()


func play_sound():
	$AudioStreamPlayer.play()
