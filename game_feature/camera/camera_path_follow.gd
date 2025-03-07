extends PathFollow3D

signal change_camera
@export var speed : int = 4

var show_level = true
var restart = false

func _process(delta):
	
	if show_level:
		progress += speed * delta
	
	if progress_ratio > 0.98:

		$Camera3D.set_current(false)
		emit_signal("change_camera")


func _unhandled_input(event):
	if event.is_action_pressed("camera"):
		show_level = true
		$Camera3D.set_current(true)
		if !restart:
			progress = 0
			restart = true
	if event.is_action_released("camera"):
		show_level = false
		$Camera3D.set_current(false)
		emit_signal("change_camera")
