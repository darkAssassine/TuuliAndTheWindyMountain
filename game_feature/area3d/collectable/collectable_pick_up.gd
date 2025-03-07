extends Area3D

signal picked_item(a : int)

@export var left : bool 
@export var mid : bool 
@export var right : bool 
var player
var play_sound = true
func _ready():
	$AnimatedSprite3D.play("idle")


func _on_body_entered(body):
	if body.has_method("player"):
		
		player = body
		$AnimationPlayer.play("collect")
		if play_sound:
			$AudioStreamPlayer.play()
			play_sound = false
			
func end_of_animation():
	if left:
		player.left = true
	if mid:
		player.mid = true
		
		
	if right:
		player.right = true
		
	queue_free()
