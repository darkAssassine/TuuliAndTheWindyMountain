extends Control

var left_animation = true
var mid_animation = true
var right_animation = true

func _ready():
	$Left.visible = false
	$Mid.visible = false
	$Right.visible = false
	
func _physics_process(delta):
	if get_tree().paused:
		visible = false
	else: 
		visible = true
	
	
	
	if $Left.visible && left_animation:
		left_animation = false
		$Left.play("default")
	elif !$Left.visible:
		left_animation = true
	
	if $Mid.visible && mid_animation:
		mid_animation = false
		$Mid.play("default")
	elif !$Mid.visible:
		mid_animation = true
	
	
	if $Right.visible && right_animation:
		right_animation = false
		$Right.play("default")
	elif !$Right.visible:
		right_animation = true
