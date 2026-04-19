class_name LeverEntity
extends Entity

var c_activateable :=  ActivateableComponent.new()

func _init(p_game_state: GameStateContext, p_connected_door_entity_id: int, p_initial_state: Dictionary) -> void:
	var new_state := {
		connected_door_entity_id = p_connected_door_entity_id
		}
	new_state.merge(p_initial_state, true)

	components = [c_activateable]

	super(p_game_state, new_state)

## @deprecated: use components and systems
func is_activated() -> bool:
	var data := get_typed_data()
	return data.state == LeverStruct.State.Activated

func on_interact(_from_entity_id: int, to_entity_id: int) -> void:
	if to_entity_id != entity_id:
		return
	ActivateableComponent.get_c(game_state, entity_id).toggle()

func get_typed_data() -> LeverStruct:
	var data : Dictionary = game_state.get_entity_data(entity_id)
	return LeverStruct.from_dict(data)

