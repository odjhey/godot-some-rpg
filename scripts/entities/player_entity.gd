class_name PlayerEntity
extends Entity

var c_looter := LooterComponent.new()

func _init(p_game_state: GameStateContext, p_initial_state: Dictionary) -> void:
	components = [c_looter]
	super(p_game_state, p_initial_state)

func interact(p_game_state: GameStateContext, p_target_entity_id: int) -> void:
	p_game_state.send_interact(entity_id, p_target_entity_id)

