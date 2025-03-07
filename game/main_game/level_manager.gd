extends Node

@export var player : CharacterBody3D

var levels = [
	preload("res://levels/Game_Levels/Level_1.tscn"),
	preload("res://levels/Game_Levels/Level_2.tscn"),
	preload("res://levels/Game_Levels/Level_3.tscn"),
	preload("res://levels/Game_Levels/Level_4.tscn"),
	preload("res://levels/Game_Levels/Level_5.tscn"),
	preload("res://levels/Game_Levels/Level_6.tscn"),
	preload("res://levels/Game_Levels/Level_7.tscn"),
	preload("res://levels/Game_Levels/Level_8.tscn"),
	]
	
var next_level: PackedScene
var previous_level : PackedScene
var start_spawn : Vector3
var end_spawn: Vector3
var is_next_level_previous = false
var index : int = 0
var value : int
var can_shoot : bool = true

func load_next_level(value1):
	player.is_freezed = false
	player.talking = false
	player.enable()
	if can_shoot:
		value = value1
		player.disable()
		index += value
		ScreenTransition.fade_in("left_to_right_fade_in")
		await ScreenTransition.finished
		ScreenTransition.blank_screen("blank_screen")
		for a in get_children():
			if a is Node3D:
				remove_child(a)
				a.queue_free()
			
		var level = levels[index].instantiate() 
		level.position = Vector3.ZERO
		add_child(level)
		$Timer.start()

		
func _on_timer_timeout():
	player.is_freezed = false
	player.enable()
	if value >= 0:
		player.left = false
		player.mid = false
		player.right = false
		player.respawn_position = start_spawn
		player.global_position = start_spawn
	if value < 0:
		player.left = false
		player.mid = false
		player.right = false
		player.respawn_position = end_spawn
		player.global_position = end_spawn
	ScreenTransition.fade_out("left_to_right_fade_out")
	await ScreenTransition.finished
	ScreenTransition.visible = false
	
func _on_player_player_died():
	player.is_freezed = false
	player.respawn
	player.enable()
	for a in get_children():
		if a is Node3D:
			remove_child(a)
			a.queue_free()
	var level = levels[index].instantiate()
	level.position = Vector3.ZERO
	add_child(level)
	ScreenTransition.visible = false

