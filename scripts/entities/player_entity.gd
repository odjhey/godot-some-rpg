class_name PlayerEntity
extends Entity

func interact(p_game_state: GameStateContext, p_target_entity_id: int):
	p_game_state.send_interact(entity_id, p_target_entity_id)

