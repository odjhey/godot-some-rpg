class_name DoorEntity
extends Entity

var c_openable := OpenableComponent.new()
signal visual_update_state_changed(state: OpenableComponent.State)

func _init(p_game_state: GameStateContext, p_initial_state: Dictionary) -> void:
	var new_state := {}
	new_state.merge(p_initial_state, true)

	components = [c_openable]

	super(p_game_state, new_state)

	c_openable.changed.connect(func() -> void:
		visual_update_state_changed.emit(c_openable.state)
	)

func is_open() -> bool:
	var data := game_state.get_entity_data(entity_id)
	return data.get("state") == ChestStruct.State.Open


