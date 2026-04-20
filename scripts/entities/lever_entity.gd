class_name LeverEntity
extends Entity

var c_activateable :=  ActivateableComponent.new()

func _init(p_game_state: GameStateContext, p_initial_state: ActivateableComponent.State) -> void:
	c_activateable.state = p_initial_state
	components = [c_activateable]
	super(p_game_state, {})

func on_interact(_from_entity_id: int, to_entity_id: int) -> void:
	if to_entity_id != entity_id:
		return
	ActivateableComponent.get_c(game_state, entity_id).toggle()
