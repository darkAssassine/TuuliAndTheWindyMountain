extends Control

signal back_to_previous
signal restart_game
var a = true

func _ready():
	visible = false


		
func _unhandled_input(event):
	if event.is_action("escape") && visible:
		_on_back_button_up()

func _on_back_button_up():
	if a:
		visible = false
		emit_signal("back_to_previous")
		if !$BK.visible:
			emit_signal("restart_game")
	
func show_credits(is_in_menu):
	$AnimationPlayer.play("play_credits")
	a = is_in_menu
	visible = true
	if is_in_menu:
		$BK.visible = true
	else:
		$BK.visible = false
		
	$TutorialPlus.visible = a
