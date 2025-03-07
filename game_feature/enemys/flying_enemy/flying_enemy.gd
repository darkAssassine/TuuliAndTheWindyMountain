extends PathFollow3D

@export var move_speed :float = 2
@export var up_down_speed : float = 0.5
@export var freeze_duration : float = 2
@export var cooldown : float = 1
@export var enemy_bullet : PackedScene

var a : AnimationPlayer
var player = 0
var can_damage = true
var direction : Vector2 = Vector2.ZERO
var is_dead = false
var is_freezed = false
var can_shoot = true
var freeze_timer_started = false
var cooldown_timer_started = false
var in_range = false
var is_player_colliding = false

@onready var freeze_timer = $Path3D/RangedEnemy/FreezeTimer
@onready var cooldown_timer = $Path3D/RangedEnemy/Cooldown
@onready var original_move_speed = move_speed
@onready var original_up_down_speed = up_down_speed

func _ready(): 
	$Path3D/RangedEnemy/FlyingEnemy/AnimationPlayer.play("idle")
	freeze_timer.wait_time = freeze_duration
	cooldown_timer.wait_time = cooldown
	$Path3D/RangedEnemy/Propeller/AnimationPlayer.play("idle_propeller")
	$Path3D/RangedEnemy/FreezeSprite.visible = false
	
func _physics_process(delta):
	if $PropellerSound.playing == false:
		$PropellerSound.play()
	if !is_dead && !is_freezed:
		progress +=  move_speed *  delta
		$Path3D/RangedEnemy.progress += up_down_speed * delta
	
		if progress_ratio>0.95 && move_speed >0:
			move_speed = -abs(move_speed)
			$Path3D/RangedEnemy/RangeLine.target_position.x = -abs($Path3D/RangedEnemy/RangeLine.target_position.x)
			$Path3D/RangedEnemy/FlyingEnemy.flip_h = true
			$Path3D/RangedEnemy/BulletSpawn.position.x = -abs($Path3D/RangedEnemy/BulletSpawn.position.x)
			$Path3D/RangedEnemy/RangeArea.position.x = -abs($Path3D/RangedEnemy/RangeArea.position.x)
			

		if $Path3D/RangedEnemy.progress_ratio>0.95 && up_down_speed >0:
			up_down_speed = -abs(up_down_speed)
		
		
		
		if progress_ratio < 0.05 && move_speed <0:
			move_speed = abs(move_speed)
			$Path3D/RangedEnemy/RangeLine.target_position.x = abs($Path3D/RangedEnemy/RangeLine.target_position.x)
			$Path3D/RangedEnemy/FlyingEnemy.flip_h = false
			$Path3D/RangedEnemy/BulletSpawn.position.x = abs($Path3D/RangedEnemy/BulletSpawn.position.x)
			$Path3D/RangedEnemy/RangeArea.position.x = abs($Path3D/RangedEnemy/RangeArea.position.x)
			
		if $Path3D/RangedEnemy.progress_ratio < 0.05 && up_down_speed <0:
			up_down_speed = abs(up_down_speed)
		
	if player:
		if is_player_colliding && player.is_dashing && is_freezed:
			$Path3D/RangedEnemy/FlyingEnemy/AnimationPlayer.play("dead")
			$Path3D/RangedEnemy/FreezeSprite/AnimationPlayer.play("unfreeze")
			$UnfreezeSound.play()
			$DeathSound.play()
			$Timer.start()
		if in_range && can_shoot && !is_freezed:
			$Path3D/RangedEnemy/FlyingEnemy/AnimationPlayer.play("shoot")
			$ShootAntisipationSound.play()
		
			move_speed = 0
			up_down_speed = 0
	if player:
		if player.is_dead:
			in_range = false
		if is_dead && player.is_dead:
			respawn()

func flying_enemy():
	pass
		
func shoot():
	if can_shoot:
		if in_range:
			$Path3D/RangedEnemy/Bullets.global_position = Vector3.ZERO
			$Path3D/RangedEnemy/Bullets.position = Vector3.ZERO
			can_shoot = false
			cooldown_timer.start()
			direction = Vector2(player.global_position.x, player.global_position.y)- Vector2(global_position.x, global_position.y)                                               
			direction = direction.normalized()
			var b = enemy_bullet.instantiate()
			b.position = Vector3.ZERO
			$Path3D/RangedEnemy/Bullets.add_child(b)
			b.global_position = $Path3D/RangedEnemy/BulletSpawn.global_position
			b.direction = direction
			b.rotation.z =direction.angle()
		
	if !is_freezed:
		$Path3D/RangedEnemy/FlyingEnemy/AnimationPlayer.play("idle")
	move_speed = original_move_speed
	up_down_speed = original_up_down_speed
	
func on_cooldonw_timeout():
	can_shoot = true

func freeze():
	can_shoot = false
	can_damage = false
	move_speed = 0
	up_down_speed = 0
	is_freezed = true
	$Path3D/RangedEnemy/FreezeSprite/AnimationPlayer.play("freeze")
	$Path3D/RangedEnemy/FlyingEnemy/AnimationPlayer.stop(true)
	$FreezeSound.play()

	$Path3D/RangedEnemy/FreezeSprite.visible = true
	freeze_timer.start()

func on_freeze_timer_timeout():
	if !is_dead:
		$Path3D/RangedEnemy/FreezeSprite/AnimationPlayer.play("unfreeze")
		$UnfreezeSound.play()

func unfreeze():
	if !is_dead:
		can_damage = true
		move_speed = original_move_speed
		up_down_speed = original_up_down_speed
		is_freezed = false
	$Path3D/RangedEnemy/FlyingEnemy/AnimationPlayer.stop(false)
	$Path3D/RangedEnemy/FreezeSprite.visible = false
		
func respawn():
	pass
	
func on_dead():
	queue_free()
	$Path3D/RangedEnemy/FreezeSprite.visible = false
	visible = false
	move_speed = 0
	up_down_speed = 0
	can_shoot = false
	is_dead = true
	$Path3D/RangedEnemy/StaticBody3D/CollisionShape3D.disabled = true
	$Path3D/RangedEnemy/FreezeSprite.visible = false
func player_entered_range(body):
	if body.has_method("player"):
		player = body
		in_range = true


func player_exited_range(body):
	if body.has_method("player"):
		in_range = false
		if !is_freezed:
			$Path3D/RangedEnemy/FlyingEnemy/AnimationPlayer.play("idle")
		move_speed = original_move_speed
		up_down_speed = original_up_down_speed
		
func player_entered_hitbox(body):
	if body.has_method("player"):
		player = body
		is_player_colliding = true
		if can_damage:
			player.on_dead()
			
func player_exited_hitbox(body):
	if body.has_method("player"):
		is_player_colliding = false


func _on_hit_box_area_entered(area):
	if area.has_method("bullet"):
		freeze()

func invisible():
	$Path3D/RangedEnemy/FreezeSprite.visible = false


func _on_timer_timeout():
	queue_free()

func shoot_sound():
	$ShootSound.play()
