extends Area3D

signal wind_stop
signal wind_start
var player : bool = false
var box : bool = false

func _on_body_entered(body):
	if body.has_method("player"): 
		emit_signal("wind_stop")
		emit_signal("wind_start")
		player = true
		
	if body.has_method("move_able_box"):
		emit_signal("wind_stop")
		emit_signal("wind_start")
		box = true



func _on_body_exited(body):
	if body.has_method("player") && !box: 
		emit_signal("wind_stop")
		emit_signal("wind_start")
		
	if body.has_method("move_able_box") && !player:
		emit_signal("wind_stop")
		emit_signal("wind_start")
