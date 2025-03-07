extends Node3D

signal respawn
signal relaod_level
var is_visible : bool = false
var invisible_cursor = load("res://game/mouse_cursor/invisble_mouse_courser.png")
var is_respawn = false
@onready var screens = $Screens




func _process(delta):
	
	if $Screens/GameOverScreen.visible || $Screens/StartMenu.visible || $Screens/Settings.visible || $Screens/PauseMenu.visible || $Screens/Credits.visible:
		is_visible = true
	
	else:
		is_visible = false
	if is_visible:
		get_tree().paused = true
		

	else:
		get_tree().paused = false

	
func player_died():
	if !is_respawn:
		$Screens/GameOverScreen.visible = true
	
func _unhandled_input(event):
	
	if $Screens/GameOverScreen.visible == false && event.is_action("restart"): 
		emit_signal("respawn")
		$Player.visible = true
		$Player.anim_can_change = true
		$Screens/GameOverScreen.visible = false
		$Levels._on_player_player_died()
		$Player.set_animation("idle")
	else:
		if event is InputEventKey && $Screens/GameOverScreen.visible:
			emit_signal("respawn")
			$Player.visible = true
			$Screens/GameOverScreen.visible = false
			$Player.anim_can_change = true
			$Player.respawn()
			$Player.set_animation("idle")
		
	if event.is_action_released("pause"):
		if !is_visible:
			pass
			
		if $Screens/PauseMenu.visible: 
			$Screens/PauseMenu.visible = false
		
		elif !$Screens/StartMenu.visible && !$Screens/Settings.visible:
			$Screens/PauseMenu.visible = true
			get_tree().paused = true
		
		print("ok")

func restart_game():
	$Screens/Credits.show_credits(false)
	
func anim_finished(name):
	get_tree().change_scene_to_file("res://game/main_game/game.tscn")

