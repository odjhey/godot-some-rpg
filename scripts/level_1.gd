extends Node

@onready var label : Label = $Label
@onready var game_state : GameState = $GameState


func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	label.text = str(game_state.context.entity_tags)
