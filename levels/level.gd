extends Node3D

signal player_exited(value:int)

@export var start_spawn: Node3D
@export var end_spawn: Node3D 


func _ready():
	get_parent().start_spawn = Vector3(start_spawn.global_position.x, start_spawn.global_position.y, 0)
	get_parent().end_spawn = Vector3(end_spawn.global_position.x, end_spawn.global_position.y, 0)
	
	
func load_next_level():
	get_parent().load_next_level(1)

func load_previous_level():
	get_parent().load_next_level(-1)	
