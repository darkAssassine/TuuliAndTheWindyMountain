extends Area3D

@export var is_enabled : bool = true
@export var wind_strenght : Vector2 = Vector2.ZERO
@export var max_wind_strenght : Vector2 = Vector2(20,20)
@export_enum("up","down", "left", "right") var direction : String

var player = 0
var box = 0


func _physics_process(delta):
	
	if player && box && is_enabled:
		if direction == "up":
			if player.left_marker_position.x > box.bottom_left.x && player.right_marker_position.x < box.top_right.x && player.left_marker_position.y > box.top_right.y:
				player.wind = Vector2.ZERO
			else:
				player.wind = wind_strenght
				
		if direction == "down":
			if player.left_marker_position.x > box.bottom_left.x && player.right_marker_position.x < box.top_right.x && player.left_marker_position.y < box.top_right.y:
				player.wind = Vector2.ZERO
			else:
				player.wind = wind_strenght	
		if direction == "left":
			if player.left_marker_position.y > box.bottom_left.y && player.right_marker_position.y < box.top_right.y && player.left_marker_position.x < box.top_right.x:
				player.wind = Vector2.ZERO
			else:
				player.wind = wind_strenght
				
		if direction == "right":
			if player.left_marker_position.y > box.bottom_left.y && player.right_marker_position.y < box.top_right.y && player.left_marker_position.x > box.top_right.x:
				player.wind = Vector2.ZERO
			else:
				player.wind = wind_strenght
				
	elif player && !box && is_enabled:
		player.wind = wind_strenght
	
	if !is_enabled && player:
		player.wind = Vector2.ZERO
		
func _wind_entered(body):
	print(body.name)
	if body.has_method("player"):
		player = body
		body.wind = wind_strenght
		body.max_wind_speed = max_wind_strenght
	if body.has_method("move_able_box"):
		box = body
		print("ok")
	
		
func _wind_exited(body):
	if body.has_method("player"):
		player = 0
		body.wind = Vector2.ZERO
		body.max_wind_speed = Vector2.ZERO
	if body.has_method("move_able_box"):
		box = 0
		

func enable():
	is_enabled = true
	
func disable():
	is_enabled = false


func _on_audio_stream_player_3d_finished():
	$AudioStreamPlayer3D.play()
