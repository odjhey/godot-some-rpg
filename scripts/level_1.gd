extends Node

@onready var label : Label = $Label
@onready var game_state : GameState = $GameState


func _ready():
	pass

func _process(_delta):
	label.text = str(game_state.context.entity_tags)
