extends Node


@export var game_state_node: GameState
var game_state: GameStateContext

var gs : GameStateContext
@export var chests_requirements : Array[ChestNode]
@export var chest : Door

var open_chest_system : OpenIfLinkedActivatedSytem

func _ready() -> void:
	game_state = game_state_node.context
	var c_activatables: Array[ActivateableComponent] = []
	for c in chests_requirements:
		c_activatables.append(c.entity.c_activateable)
	open_chest_system = OpenIfLinkedActivatedSytem.new(game_state, chest.entity.c_openable, c_activatables)
