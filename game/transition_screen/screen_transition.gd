extends CanvasLayer
signal finished

func _ready():
	visible = false

func fade_out(transition_typ:String):
	visible = true
	$AnimationPlayer.play(transition_typ)
	await $AnimationPlayer.animation_finished
	visible = false
	emit_signal("finished")
	
func fade_in(transition_typ:String):
	visible = true
	$AnimationPlayer.play(transition_typ)
	await $AnimationPlayer.animation_finished
	visible = false
	emit_signal("finished")

func blank_screen(animation: String):
	visible = true
	$AnimationPlayer.play(animation)
