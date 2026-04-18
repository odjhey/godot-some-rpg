class_name Chest
extends Node2D

@onready var close_sprite : Sprite2D = $Close
@onready var open_sprite : Sprite2D = $Open

func open() -> void:
	close_sprite.visible = false
	open_sprite.visible = true

func close() -> void:
	close_sprite.visible = true
	open_sprite.visible = false
