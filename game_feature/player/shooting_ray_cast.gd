extends RayCast3D

func _physics_process(delta):
	var velocity_vector : Vector2 = Vector2.from_angle(global_rotation.z)
	
	if is_colliding():

			if get_collider().has_method("destroy_tile"):
			
			#$RayCast3D.get_collider().destroy_tile($RayCast3D.get_collision_point()- $RayCast3D.get_collision_normal() )
				get_collider().destroy_tile_square(get_collision_point()+ Vector3(velocity_vector.x/10,velocity_vector.y/10,0) )
	


func _on_timer_timeout():
	enabled = false
