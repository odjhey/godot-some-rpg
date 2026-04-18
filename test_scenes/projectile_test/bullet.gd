class_name Bullet
extends RigidBody2D


var n_rotation : Vector2
var speed := 2000
var direction : Vector2 = Vector2.RIGHT

func setup(_p_rotation: Vector2) -> void:
	pass

func _ready() -> void:
	linear_velocity = direction.normalized() * speed
		

