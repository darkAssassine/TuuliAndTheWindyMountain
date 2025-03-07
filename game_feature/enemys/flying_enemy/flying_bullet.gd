extends Area3D

var direction: Vector2 = Vector2.ZERO
@export var speed = 30
var can_damage = true

func _ready():
	$AnimationPlayer.play("idle")
	$CollisionShape3D.disabled = false
	$AnimatedSprite3D2.play("default")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	position.x += speed * direction.x * delta
	position.y += speed * direction.y * delta
	
	
func _on_body_entered(body):
	if body.has_method("player") && can_damage:
		body.on_dead()
	if !body.has_method("flying_enemy"):
		$CollisionShape3D.disabled = true
		$AnimationPlayer.play("dead")
		$AnimatedSprite3D2.visible = false
		can_damage = false
		speed = 0

func dead():
	queue_free()
