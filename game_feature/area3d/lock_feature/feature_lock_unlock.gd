extends Area3D

@export var dash_able : bool
@export var shoot_able : bool
@export var umbrella_open_able : bool
@export var animated_sprite : AnimatedSprite3D
@export var play_sound = true

func _ready():
	if animated_sprite:
		animated_sprite.play("default")

func player_entered(body):
	if body.has_method("player"):
		$Timer.start()
		body.can_dash1 = dash_able
		body.can_shoot = shoot_able
		body.can_open_umbrella = umbrella_open_able 
		visible = false
		if play_sound :
			$AudioStreamPlayer.play()
			play_sound = false

func _on_timer_timeout():
	queue_free()
