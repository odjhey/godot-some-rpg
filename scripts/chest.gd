extends Node2D

enum ChestState {Open, Close}
var state : ChestState = ChestState.Close
@onready var close_sprite : Sprite2D = $Close
@onready var open_sprite : Sprite2D = $Open

func open():
	state = ChestState.Open
	close_sprite.visible = false
	open_sprite.visible = true

func close():
	state = ChestState.Open
	close_sprite.visible = true
	open_sprite.visible = false
