class_name BaseEnemy
extends CharacterBody3D


@export var speed : float = 1
@export var freeze_time :float = 2
@export var normal_color : Color
@export var freeze_color : Color
var can_damage = true
var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity")
var direction : int = 1
var player

enum state{
	idle,
	chase,
	run_away,
	freeze,
}

var timer_started = false
@onready var anim_player = $AnimationPlayer
@onready var current_state : state = state.idle

func _ready():
	$FreezeTimer.wait_time = freeze_time

func _physics_process(delta):
	if player:
		if player.is_dashing && current_state == state.freeze:
			queue_free()
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if current_state == state.idle:
		idle()
	
	elif current_state == state.chase:
		chase()
	
	elif current_state == state.run_away:
		run_away()
	
	elif current_state == state.freeze:
		$Sprite3D.modulate = freeze_color
		freeze(delta)
		
	move_and_slide()
	
	
	
func set_direction_to_negativ(body):
	if !body.has_method("player"):
		direction = -1

func set_direction_to_positiv(body):
	if !body.has_method("player"):
		direction = 1

func idle():
	$AnimatedSprite3D.visible = false
	velocity.x = speed * direction


		
func run_away():
	pass

func chase():
	pass
	
	
func freeze(delta):
	velocity.x = 0
	can_damage = false
	$AnimatedSprite3D.visible = true
	if timer_started ==false:
	
		$FreezeTimer.start()
		timer_started = true


func freeze_timeout():
	current_state = state.idle
	timer_started = false
	$Sprite3D.modulate = normal_color
	can_damage = true
	anim_player.play_backwards("freeze")
	
func enemy():
	pass


func player_entered(body):
	if body.has_method("player"):
		player = body
		if body.is_dashing && current_state == state.freeze:
			queue_free()
		else:
			if can_damage: 
				body.on_dead()
	pass # Replace with function body.

















































































































func player_exited(body):
	if body.has_method("player"):
		player = 0
