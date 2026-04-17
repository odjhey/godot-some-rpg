class_name Entity
extends RefCounted

var entity_id: int
var game_state: GameStateContext

func _init(p_game_state: GameStateContext, p_initial_state: Dictionary):
	game_state = p_game_state
	entity_id = p_game_state.create_entity(p_initial_state)
