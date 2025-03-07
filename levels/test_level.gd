extends Node3D

func _unhandled_input(event):
	if event.is_action("restart"):
		get_tree().reload_current_scene()
