extends Node3D

var DIRECTION

func delete_children():
	for a in get_children():
		if a is CharacterBody3D:
			remove_child(a)
			a.queue_free()
