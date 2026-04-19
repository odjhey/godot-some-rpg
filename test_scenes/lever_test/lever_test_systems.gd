extends Node

@export var game_state_node: GameState
var game_state: GameStateContext

var gs : GameStateContext
@export var lever_requirements : Array[LeverNode]
@export var chest : Door

var open_chest_system : OpenIfLinkedActivatedSytem

func _ready() -> void:
	game_state = game_state_node.context
	var c_activatables: Array[ActivateableComponent] = []
	for l in lever_requirements:
		c_activatables.append(l.entity.c_activateable)
	open_chest_system = OpenIfLinkedActivatedSytem.new(game_state, chest.entity.c_openable, c_activatables)
