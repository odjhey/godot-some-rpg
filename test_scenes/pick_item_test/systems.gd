extends Node

@export var game_state_node: GameState
var game_state: GameStateContext

var gs : GameStateContext
@export var players : Array[PlayerNode]

var autopick_system : AutopickNearbySystem

func _ready() -> void:
	game_state = game_state_node.context
	var c_looters: Array[LooterComponent] = []
	for p in players:
		c_looters.append(p.entity.c_looter)
	autopick_system = AutopickNearbySystem.new(game_state, c_looters)
	autopick_system.picked.connect(on_item_picked)

func on_item_picked(_p_by: int, p_entity_id: int) -> void:
	game_state_node.get_entity_node(p_entity_id).queue_free()
