extends CharacterBody3D

signal player_died
signal has_shoot(spawn_position : Vector2 , direction)
signal player_aim(spawn_position : Vector2 , direction)
signal set_camera(player_position:Vector3)
signal camera_shake

@export var speed : float = 8
@export var jump_strenght : float = 9.5

@export var dash_time = 0.2
@export var dash_speed : float = 20
@export var dash_cooldwon = 1
@export var gravity_multiplier : float = 2

@export var wind_multi : float = 1.2
@export var wind_dampening : float = 500
@export var out_of_wind_time : float = 0.2

@export var slow_speed :float = 5
@export var floating_speed : float = 3
@export var fast_floating_speed = 4

@export var cojote_time : float = 0.1
@export var original_jump_buffer_time : float = 0.1
@export var frezze_timer_wait_timer : float = 0.1
@export var sprite_offset_x :float = 0.12
@export var run_partice_spawn_timer : float = 0.1
@export var run_partice : PackedScene
@export var dash_vfx_timer : float = 0.01
@export var dash_vfx : PackedScene
@export var knockback_duration: float = 3


var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity")
var direction : int
var last_direction : int 
var knockback : float 

var plattfrom_speed : float= 0
var enemy
var wind : Vector2 = Vector2.ZERO
var max_wind_speed = Vector2.ZERO
var shoot_direction : Vector2 = Vector2.ZERO
var umbrella_rotation : Vector2 = Vector2.ZERO
var dash_direction


var is_umbrella_open : bool = false
var is_dashing : bool = false
var can_damage : bool = false
var can_jump : bool = true
var is_aiming : bool = false

var is_freezed : bool = false
var is_gravity : bool = true
var dash_input : bool = false
var shoot_input: bool = false
var shoot_cooldown_over = true
var unfreeze_timer_started : bool = false

var can_open_umbrella = true
var can_dash = true
var can_dash1 = true
var can_shoot = true
var can_move = true
var animation_playing = false
var is_falling = false

var x_wind_rotation : float
var y_wind_rotation : float
var is_last_input_gamepad


@onready var left_marker_position = $LeftMarker.position
@onready var right_marker_position = $RightMarker.position
@onready var original_run_partice_spawn_timer : float = run_partice_spawn_timer
@onready var respawn_position = global_position
@onready var walk_sound : AudioStreamPlayer = $WalkSound
@onready var dash_sound : AudioStreamPlayer = $DashSound

@onready var jump_buffer_time = 0
@onready var original_speed : float = speed
@onready var dash_timer : Timer = $DashTimer
@onready var original_out_of_wind_time : float = out_of_wind_time
@onready var original_cojote_time : float = cojote_time
@onready var original_floating_speed : float = floating_speed
@onready var original_gravity : float = gravity
@onready var anim_player = $AnimationPlayer
@onready var sprite_x_position = $AnimatedSprite3D.position.x
@onready var original_dash_vfx_timer = dash_vfx_timer


func _ready():
	position.z = 0
	last_direction = 1
	dash_timer.wait_time = dash_time
	$DashCooldown.wait_time = dash_cooldwon
	$FrezzeTimer.wait_time = frezze_timer_wait_timer

func _physics_process(delta):
	
	left_marker_position = $LeftMarker.global_position
	right_marker_position = $RightMarker.global_position
	
	if velocity == Vector3(0,0,0)|| (!direction && !velocity.y):
		set_animation("idle")
	if enemy:
		if enemy.can_damage:
			on_dead()
	if can_dash:
		
		$ProgressBar.visible = false
		$ProgressBar.max_value = dash_cooldwon
		$ProgressBar.value =$ProgressBar.max_value- $DashCooldown.time_left / dash_cooldwon
		$Umbrella/Sprite3D.modulate = Color(1,1,1)
		
	else:
		$ProgressBar.visible = false
		$Umbrella/Sprite3D.modulate = Color(0.9,0.5,0.5)
		
	if !is_freezed:
		try_jump(delta)
		
		
		if can_move:
			movement(delta)
		
		emit_signal("set_camera", Vector3(global_position.x , global_position.y, global_position.z))
		move_and_slide()
	
		play_sound()
		if dash_input:
			dash()
		if shoot_input:
			shoot()
	else:
		if unfreeze_timer_started == false:
			$FrezzeTimer.start()
			unfreeze_timer_started = true
	rotate_umbrella(delta)
	check_umbrella(delta)
	if is_dashing:
		dashing(delta)
	
	if Input.is_action_just_released("shoot") && is_umbrella_open && can_shoot &&shoot_cooldown_over:
		shoot()
	if direction:
		if is_on_floor():
			set_animation("run")
			
func _unhandled_input(event):
	if event is InputEventKey or event is InputEventMouse:
		is_last_input_gamepad = false
	else:
		is_last_input_gamepad = true
		
	if !is_freezed:
		if event.is_action_pressed("dash") && can_dash1 && can_dash && is_umbrella_open:
			if not is_dashing:
				dash_input = true
				is_freezed = true
				
		if event.is_action_pressed("shoot"):
			#hoot_input = true
			is_freezed = true
			is_aiming = true
			
		if event.is_action_released("shoot"):
			is_aiming = false
		if event.is_action_released("shoot") && can_shoot:
			
			is_aiming = false

func movement(delta):
	print(wind)
	if is_on_floor():
		run_partice_spawn_timer += delta
		if run_partice_spawn_timer > original_run_partice_spawn_timer:
			run_partice_spawn_timer = 0
			if direction:
				var image = run_partice.instantiate()
				image.position = Vector3(0,0,-0.1)
				$Particle.add_child(image)
				if direction < 0:
					image.global_position = $ParticleSpawnPosition.global_position 
				else:
					image.global_position = $ParticleSpawnPosition.global_position 
	
	if is_falling && is_on_floor():
		is_falling = false
		set_animation("fall_ended")
		
		pass
	direction = Input.get_axis("left", "right")
	
	if direction:
		last_direction = direction
		if direction < 0:
			pass
		else:
			pass
	if !wind:
		out_of_wind_time -= delta
		
	if wind || is_on_floor():
		out_of_wind_time = original_out_of_wind_time
	
func try_jump(delta):
	jump_buffer_time -= delta
	if not is_on_floor():
		not_on_floor(delta)
	
	else:
		cojote_time = original_cojote_time
		can_jump = true
	
	if Input.is_action_just_pressed("jump"):
		jump_buffer_time = original_jump_buffer_time
	
	if (Input.is_action_just_pressed("jump") || jump_buffer_time > 0)and can_jump:
		velocity.y = jump_strenght
		set_animation("jump")
		can_jump = false

func check_umbrella(delta):
	if Input.is_action_pressed("umbrella_open") && can_open_umbrella:
		is_umbrella_open = true
		umbrella_open(delta)
	else:
		is_umbrella_open = false
		umbrella_closed(delta)

func umbrella_closed(delta):
	$Umbrella.visible = false 
	if last_direction < 0:
		$AnimatedSprite3D.flip_h = true
		$AnimatedSprite3D.position.x = sprite_offset_x
	elif last_direction > 0:
		$AnimatedSprite3D.flip_h = false
		$AnimatedSprite3D.position.x = sprite_x_position
	
	if can_move:
		velocity.x =  wind.x + (speed * direction) + plattfrom_speed + knockback

		knockback = lerpf(knockback, 0, delta * knockback_duration)
		
		
	if wind.x:
		if velocity.x >= max_wind_speed.x:
			velocity.x = max_wind_speed.x

func umbrella_open(delta):
	
	if last_direction < 0:
		$AnimatedSprite3D.flip_h = true
		$AnimatedSprite3D.position.x = sprite_offset_x
	elif last_direction > 0:
		$AnimatedSprite3D.flip_h = false
		$AnimatedSprite3D.position.x = sprite_x_position
	$Umbrella.visible = true
	
	if can_move:
		velocity.x = (wind.x * wind_multi * x_wind_rotation) + (speed * direction ) + (plattfrom_speed) +knockback
		
	
		knockback = lerpf(knockback, 0, delta * knockback_duration)
		
		
	if wind.x:
		if velocity.x >= max_wind_speed.x && max_wind_speed.x >0:
			velocity.x = max_wind_speed.x
		if velocity.x < max_wind_speed.x && max_wind_speed.x < 0:
			velocity.x = max_wind_speed.x
	if wind.y:
		if velocity.y >= max_wind_speed.y && max_wind_speed.y >0:
			velocity.y = max_wind_speed.y
		if velocity.y < max_wind_speed.y && max_wind_speed.y < 0:
			velocity.y = max_wind_speed.y
			
			
		set_animation("fly")
		velocity.y += wind.y * delta

	
		
func not_on_floor(delta):
	
	if is_gravity:
		
		cojote_time -= delta 
	
		if cojote_time > 0 && can_jump:
			can_jump = true
	
		else:
			can_jump = false
			

	if is_umbrella_open && out_of_wind_time < 0:
		if umbrella_rotation.y && velocity.y<0: 
			
			velocity.y = -floating_speed  
			set_animation("fall_idle")
		else:
			velocity.y -= gravity * delta
			set_animation("fall_idle")
			
	else:
		if velocity.y < 0:
			set_animation("fall_idle")
			is_falling = true
			velocity.y -= gravity * delta * gravity_multiplier
			
		else:
			if !wind.y || !is_umbrella_open:
				velocity.y -= gravity * delta

func shoot():
	$Umbrella/AnimatedSprite3D.play("shoot")
	$ShootSound.play()
	emit_signal("camera_shake")
	shoot_cooldown_over = false
	$ShootCooldown.start()
	emit_signal("has_shoot", Vector2($Umbrella/Sprite3D/BSpawn.global_position.x, $Umbrella/Sprite3D/BSpawn.global_position.y), -umbrella_rotation.angle())
	shoot_input = false

func dash():	

	dash_direction = umbrella_rotation.normalized()
	print(dash_direction)
	emit_signal("camera_shake")
	dash_sound.play()
	dash_timer.start()
	is_dashing = true
	is_gravity = false
	can_move = false

	dash_input = false
	

func dashing(delta):
	velocity.x = dash_direction.x *dash_speed
	velocity.y = dash_direction.y  * dash_speed
	gravity = 0
	dash_vfx_timer += delta
	if dash_vfx_timer > original_dash_vfx_timer:
		dash_vfx_timer = 0
		var image = dash_vfx.instantiate()
		image.position = Vector3(0,0,-0.1)
		$Particle.add_child(image)
		if direction < 0:
			image.flip_sprites()
		image.global_position = $ParticleSpawnPosition.global_position 
	move_and_slide()


func rotate_umbrella(delta):
	if Input.is_action_pressed("left"):
		umbrella_rotation = Vector2(-1,0)
		speed = original_speed 
		
	if Input.is_action_pressed("right"):
		umbrella_rotation = Vector2(1,0)
		speed = original_speed 

		
	if Input.is_action_pressed("up"):
		umbrella_rotation = Vector2(0,1)
		floating_speed = original_floating_speed
	if Input.is_action_pressed("up") && Input.is_action_pressed("left"):
		umbrella_rotation = Vector2(-1,1)
		speed = slow_speed
		floating_speed = fast_floating_speed
		
	if Input.is_action_pressed("up") && Input.is_action_pressed("right"):
		umbrella_rotation = Vector2(1,1)
		speed = slow_speed
		floating_speed = fast_floating_speed
		
	$Umbrella.rotation.z = umbrella_rotation.angle()


func dash_ended():

	is_gravity = true
	speed = original_speed
	is_dashing = false
	can_move = true
	can_dash = false
	velocity.y = lerpf(velocity.y,0 , 0.5 )
	velocity.x = lerpf(velocity.x,0 , 0.5)
	gravity = original_gravity
	#velocity.y =0
	#velocity.x = 0
	$DashCooldown.start()

func play_sound():
	if direction:
		if is_on_floor():
			if walk_sound.playing == false:
				$WalkSound.play()
		else:
			$WalkSound.stop()
	else:
		$WalkSound.stop()

func player():
	pass

func on_dead():
	is_freezed = true
	visible = false
	emit_signal("player_died")

func respawn():
	is_freezed = false
	visible = true
	global_position = respawn_position
	velocity = Vector3(0,0,0)

func enemy_entered(body):
	if body.has_method("enemy"):
		enemy = body
		if body.can_damage:
			on_dead()
	if body.has_method("spikes"):
		enemy = 0
		if body.can_damage:
			on_dead()
		
func unfreeze():
	is_freezed = false

func set_animation(anim_name: String):
	anim_player.play(anim_name)
	
func cooldown_ended():
	can_dash = true

func _on_frezze_timer_timeout():
	unfreeze()
	can_move = true
	unfreeze_timer_started = false

func _on_shoot_cooldown_timeout():
	shoot_cooldown_over = true

func enemy_exited(body):
	if body.has_method("enemy") || body.has_method("spikes"):
		enemy = 0





