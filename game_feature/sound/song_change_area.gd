extends Area3D


@export var song : AudioStream
@onready var animation_player = $AnimatedSprite3D

func _ready():
	$AnimatedSprite3D.play("red")
