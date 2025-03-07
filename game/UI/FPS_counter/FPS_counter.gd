extends Label

var  FPS : int = 60


func _process(delta):
	FPS = Engine.get_frames_per_second()
	text = str(FPS)
