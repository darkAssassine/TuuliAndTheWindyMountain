extends Camera3D

@export var offset : Vector2 = Vector2(-1,-1)
@export var random_shake_strenght : float = 5
@export var shake_duration : float = 0.5
@export var max_offset_x : float = 10
@export var max_offset_y : float = 5
@export var acceleration_x : float = 3
@export var acceleration_y : float = 2

@export var max_wall_offset : Vector2 = Vector2(10,5)
@export var wall_acceleration : Vector2 = Vector2(2,1)
var wall_offset_x : float
var wall_offset_y : float
var rng = RandomNumberGenerator.new()
var shake_strenght : float = 0.0
var last_direction : Vector2 = Vector2(1,1)
@export var y_change_timer : float = 0.3
var y_can_change = true
var y_direction = -1
@export var x_change_timer : float = 0.3
var x_can_change = true
var x_direction = 1


func _ready():
	$Timer.wait_time = y_change_timer
	set_current(true)
	$Timer2.wait_time = x_change_timer
func _physics_process(delta):

	
	
	if shake_strenght >0:
		shake_strenght = lerpf(shake_strenght,0,shake_duration*delta)
	
		h_offset = random_offset().x
		v_offset = random_offset().y
	
	if abs(shake_strenght) < 0.1:
		h_offset = 0
		v_offset = 0

func set_camera(player_position):
	position.x = player_position.x
	position.y = player_position.y 

func apply_strenght():
	shake_strenght = random_shake_strenght
	
func random_offset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strenght, shake_strenght), rng.randf_range(-shake_strenght, shake_strenght))


func _on_player_camera_shake():
	apply_strenght()


func set_offset(direction : Vector2, delta:float, coll_point_x, coll_point_y):
	
	if direction.x < 0:
		direction.x = -1
	if direction.x > 0:
		direction.x = 1
		
	
	if direction.y < 0:
		direction.y = -1
	if direction.y > 0:
		direction.y = 1
	
	if direction.y == 0:
		direction.y = -1
	if direction.y == last_direction.y:
		pass
	else:
		y_can_change = false
		$Timer.start()
	
	if direction.x == 0:
		direction = last_direction
	
	if direction.x == last_direction.x:
		pass
	else:
		x_can_change = false
		$Timer2.start()
	
	if direction.x != 0:
		last_direction.x = direction.x
	if direction.y != 0:
		last_direction.y = direction.y
	
	if !y_can_change:
		direction.y = last_direction.y
	
	if !x_can_change:
		direction.x = last_direction.x
	
	if coll_point_x:
		
		wall_offset_x =  max_wall_offset.x - abs(coll_point_x)
		
		
		if wall_offset_x >= 0:
			
			position.x = move_toward(position.x ,wall_offset_x * -last_direction.x+ offset.x, wall_acceleration.x * delta)
			
		else:
			position.x = move_toward(position.x , abs(max_offset_x) * direction.x+ offset.x, acceleration_x * delta)
		
	else:
		position.x = move_toward(position.x , abs(max_offset_x) * direction.x+ offset.x, acceleration_x * delta)
		
	if coll_point_y:
		
		wall_offset_y = max_wall_offset.y - abs(coll_point_y)
		
		if wall_offset_y > 0:
			position.y = move_toward(position.y,wall_offset_y * -last_direction.y+ offset.y, wall_acceleration.y * delta)
			
		else:
			position.y = move_toward(position.y, abs(max_offset_y) * direction.y + offset.y, acceleration_y * delta)
			
	else:
		position.y = move_toward(position.y , abs(max_offset_y) * direction.y+ offset.y, acceleration_y * delta)
		
	

	
func _on_timer_timeout():
	y_can_change = true


func _on_timer_2_timeout():
	x_can_change = true
