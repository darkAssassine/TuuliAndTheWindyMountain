extends CharacterBody3D

@onready var top_right = $TopRight
@onready var bottom_left = $BottomLeft

func _physics_process(delta):
	
	top_right =  $TopRight.global_position
	bottom_left = $BottomLeft.global_position
	

func move_able_box():
	pass
