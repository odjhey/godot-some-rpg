class_name Chest
extends Node2D

enum ChestState {Open, Close}
@onready var close_sprite : Sprite2D = $Close
@onready var open_sprite : Sprite2D = $Open

func open():
	close_sprite.visible = false
	open_sprite.visible = true

func close():
	close_sprite.visible = true
	open_sprite.visible = false
