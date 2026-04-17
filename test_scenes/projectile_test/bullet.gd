class_name Bullet
extends RigidBody2D


var n_rotation
var speed = 2000
var direction : Vector2 = Vector2.RIGHT

func setup(p_rotation):
	pass

func _ready():
	linear_velocity = direction.normalized() * speed
		

