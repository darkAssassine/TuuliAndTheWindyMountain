extends Control

signal to_previous_menu


func _ready():
	#$VBoxContainer/VolumeSlider.grab_focus()
	visible = false


func _on_pause_menu_go_to_settings(a:bool):
	if a:
		$BK.visible = true
	else: 
		$BK.visible = false
	visible = true
	


func _on_start_menu_go_to_settings():
	visible = true


func _on_quit_button_up():
	emit_signal("to_previous_menu")
	visible = false
	


