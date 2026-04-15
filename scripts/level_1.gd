extends Node

@onready var label : Label = $Label
@onready var game_state : GameState = $GameState


func _ready():
	pass

func _process(delta):
	label.text = str(game_state.entity_tags)

