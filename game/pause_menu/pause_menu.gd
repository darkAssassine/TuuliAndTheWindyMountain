extends Control

signal go_to_settings(is_in_menu:bool)
signal show_main_menu
signal player_respawn
signal reload

func _ready():
	visible = false
	#$VBoxContainer/Resume.grab_focus()
	
	
func _on_resume_button_up():
	visible = false

func _on_settings_button_up():
	visible = false
	emit_signal("go_to_settings", false)
	
func _on_end_button_up():
	emit_signal("show_main_menu")
	visible = false



func _on_settings_to_pause_menu():
	visible = true

	pass # Replace with function body.


func _on_respawn_button_up():
	emit_signal("player_respawn")
	visible = false

func _on_reload_button_down():
	emit_signal("reload", int(0) )
	visible = false

func quit():
	get_tree().quit()
