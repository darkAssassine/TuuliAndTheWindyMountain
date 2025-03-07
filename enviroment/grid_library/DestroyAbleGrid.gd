extends GridMap

@export var radius : int = 3

func _ready():
	pass # Replace with function body.


func _process(delta):
	pass

func destroy_tile(collision_point):
	var map_coordinates = local_to_map(collision_point)
	set_cell_item(map_coordinates, -1)
	for i in radius+1:
		for a in radius:
			set_cell_item(map_coordinates+Vector3i(a,i,0), -1)
			set_cell_item(map_coordinates+Vector3i(a,-i,0), -1)
			set_cell_item(map_coordinates+Vector3i(i,a,0), -1)
			set_cell_item(map_coordinates+Vector3i(-i,a,0), -1)

func destroy_tile_square(collision_point):
	var map_coordinates = local_to_map(collision_point)
	set_cell_item(map_coordinates, -1)
	set_cell_item(map_coordinates+Vector3i(1,0,0), -1)
	set_cell_item(map_coordinates+Vector3i(-1,0,0), -1)
	set_cell_item(map_coordinates+Vector3i(0,1,0), -1)
	set_cell_item(map_coordinates+Vector3i(0,-1,0), -1)
	set_cell_item(map_coordinates+Vector3i(1,1,0), -1)
	set_cell_item(map_coordinates+Vector3i(-1,1,0), -1)
	set_cell_item(map_coordinates+Vector3i(1,-1,0), -1)
	set_cell_item(map_coordinates+Vector3i(-1,-1,0), -1)
