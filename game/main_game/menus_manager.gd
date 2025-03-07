extends Control

var in_main : bool = true

func _ready():
	$GameOverScreen.visible = false

func show_main_menu():
	$StartMenu.visible =true
	in_main = true


func set_in_main():
	in_main = true

func set_out_main():
	in_main = false
	
func load_previous_screen():
	if in_main:
		$StartMenu.visible = true
		$PauseMenu.visible = false
	if !in_main:
		$PauseMenu.visible = true
		$StartMenu.visible = false

func _on_start_menu_is_in_game():
	in_main = false
