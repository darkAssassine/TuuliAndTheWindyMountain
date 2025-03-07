extends Control

signal go_to_settings(is_in_menu)
signal is_in_game
signal go_to_credits(is_in_menu)

func _ready():
	visible = true





func _on_start_button_up():
	visible = false
	emit_signal("is_in_game")



func _on_end_button_up():
	get_tree().quit()


func _on_setting_button_up():
	visible = false
	emit_signal("go_to_settings", true)


func _on_credits_button_up():
	visible = false
	emit_signal("go_to_credits", true)
