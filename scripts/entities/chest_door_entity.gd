class_name ChestDoorEntity
extends Entity

signal visual_update_requested(state: ChestStruct.State)
var c_openable := OpenableComponent.new()

func _init(p_game_state: GameStateContext, p_connected_chests_entity_ids: Array[int], p_initial_state: Dictionary) -> void:
	var new_state := {
		connected_chests_entity_ids = p_connected_chests_entity_ids
		}
	new_state.merge(p_initial_state, true)
	components = [c_openable]
	super(p_game_state, new_state)

	c_openable.changed.connect(on_openable_changed)

func on_openable_changed() -> void:
	if OpenableComponent.get_c(game_state, entity_id).is_open():
		visual_update_requested.emit(ChestStruct.State.Open)
	else:
		visual_update_requested.emit(ChestStruct.State.Close)
