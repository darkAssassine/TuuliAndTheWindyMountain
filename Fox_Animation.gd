extends Node3D

var anim :String = ""

func _process(delta):
	if !$Low_Poly_Fuchs_final_perhaps_2/AnimationPlayer.is_playing() && !anim :
		$Low_Poly_Fuchs_final_perhaps_2/AnimationPlayer.play("Idle Animation_001")
	elif  !$Low_Poly_Fuchs_final_perhaps_2/AnimationPlayer.is_playing() && anim :
		$Low_Poly_Fuchs_final_perhaps_2/AnimationPlayer.play(anim)
		
func set_animation(a:String):
	$Low_Poly_Fuchs_final_perhaps_2/AnimationPlayer.play("final_transition_standup")
	anim = a


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "final_celebration_jump":
		anim = "final_talking"
