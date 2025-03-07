extends Area3D

signal show_talk_box(array : Array[String])
signal load_next_level
signal play_animation(animation: String)
signal play_new_fox_animation(animation:String)

@export var have_conversation :bool = false
@export var text : Array[String]
@export var is_tuuli_talking : Array[bool]
@export var is_fox_celebration : bool

var can_trigger = true
var player
var a = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.has_method("player") && can_trigger && have_conversation:
		a = body.can_open_umbrella
		can_trigger = false
		body.is_talking()
		player = body
		emit_signal("show_talk_box", text, is_tuuli_talking)
		emit_signal("play_animation", "Idle Animation")
		if is_fox_celebration:
			emit_signal("play_new_fox_animation", "final_celebration_jump")
		else:
			emit_signal("play_new_fox_animation", "final_talking")
		player.talking = true
		
	elif body.has_method("player") && !have_conversation:
		a = body.can_open_umbrella
		body.is_talking()
		emit_signal("load_next_level")
		player = body
		
func enable_player():
	player.talking = false
	if a:
		player.enable()
	else:
		player.enable2()

func let_player_run():
	player.play_end()
