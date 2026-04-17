extends Node2D


var bullet_scene : PackedScene = preload("res://test_scenes/projectile_test/bullet.tscn")


func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("ui_accept"):
		var bullet: Bullet = bullet_scene.instantiate()
		bullet.global_position = global_position
		bullet.direction = global_transform.x
		get_parent().add_child(bullet)
	
	if event.is_action_pressed("ui_down"):
		rotation += 1
	if event.is_action_pressed("ui_up"):
		rotation -= 1
