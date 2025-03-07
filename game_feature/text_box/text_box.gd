extends CanvasLayer

signal load_next_level

@export var print_time = 0.02
@export var skip_time = 1
var total_text  : Array[String] = [] 
var is_tuuli_talking : Array[bool] = []
var text_a : String
var text_b : String
var text_c : String
var i : int = 0
var can_show_next = false
var timer_started = false
var actual_skip_time : float = 0

@onready var label : Label = $Label
@export var original_print_time = print_time

func _ready():
	label.text = ""
	visible = false
	$Label2.visible = false
	
	$TextureProgressBar.max_value = skip_time
	
func _physics_process(delta):
	if is_tuuli_talking && label.visible_characters > 1:
		if !$TuuliSound.is_playing():
			$TuuliSound.play()
		$FoxSound.stop()
		
	elif !is_tuuli_talking && label.visible_characters > 1:
		if !$FoxSound.is_playing():
			$FoxSound.play()
		$TuuliSound.stop()
	
	if visible :
		if Input.is_action_pressed("show_next"):
			actual_skip_time += delta
		else:
			actual_skip_time = 0
		if actual_skip_time >= skip_time:
			reset()
		$TextureProgressBar.value = actual_skip_time
	else:
		$TuuliSound.stop()
		$FoxSound.stop()
	
	print_time -= delta
	
	if i >0:
		if is_tuuli_talking && i<=is_tuuli_talking.size():
			if is_tuuli_talking[i-1] == true:
				$Tuuli.visible = true
				$Foxhead.visible = false
			else:
				$Tuuli.visible = false
				$Foxhead.visible = true
	else:
		if is_tuuli_talking && i<is_tuuli_talking.size():
			if is_tuuli_talking[i] == true:
				$Tuuli.visible = true
				$Foxhead.visible = false
			else:
				$Tuuli.visible = false
				$Foxhead.visible = true
	if print_time <= 0:
		if label.visible_characters <= label.get_total_character_count():
			label.visible_characters += 1
		print_time = original_print_time
	
	if label.visible_characters >= label.get_total_character_count():
		can_show_next = true
	if !timer_started && label.visible_characters > 2 && can_show_next && total_text:
		$Timer.start()
		timer_started = true
		
	if can_show_next && Input.is_action_just_pressed("show_next") && total_text:
		if total_text.size() == i && is_visible && label.get_total_character_count() > 2:
			reset()
		else:
			add_text(total_text[i])

func _unhandled_input(event):
	if event.is_action("show_next") && visible == true && total_text.size() < i:
		add_text(total_text[i])
		
func reset():
	total_text = []
	is_tuuli_talking = []
	visible = false
	i = 0
	label.text = ""
	emit_signal("load_next_level")

func set_text(text : Array[String] , talking_person : Array[bool]):
	$AnimationPlayer.play("move_in")
	is_tuuli_talking = talking_person
	can_show_next = false
	total_text = text
	add_text(total_text[i])
	visible = true

func add_text(text : String):
	$Label2.visible = false
	can_show_next = false
	i += 1
	label.text = text
	label.visible_characters = 0


func _on_timer_timeout():
	timer_started = false
	if can_show_next:
		$Label2.visible = true



