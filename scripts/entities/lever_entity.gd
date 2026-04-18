class_name LeverEntity
extends Entity

enum LeverState {Deactivated, Activated}
signal visual_update_requested(state: LeverState)

func _init(p_game_state: GameStateContext, p_connected_door_entity_id: int, p_initial_state: Dictionary):
	var new_state = {
		connected_door_entity_id = p_connected_door_entity_id
		}
	new_state.merge(p_initial_state, true)
	super(p_game_state, new_state)

func wire_signals():
	game_state.entity_data_changed.connect(on_gs_data_changed)

func is_activated():
	var data = game_state.get_entity_data(entity_id)
	return data.get("state") == LeverState.Activated

func on_interact(_from_entity_id: int, to_entity_id: int):
	if to_entity_id != entity_id:
		return
	var data = game_state.get_entity_data(entity_id)
	var new_data = {}
	# toggle
	if data.state == LeverState.Activated:
		new_data = {state = LeverState.Deactivated}
	else:
		new_data = {state = LeverState.Activated}
	game_state.patch_entity_data(entity_id, new_data)


func on_gs_data_changed(p_entity_id: int, p_new_data):
	if p_entity_id != entity_id:
		return
	# toggle connected door state
	# @todo cache values on hot paths
	var data = game_state.get_entity_data(entity_id)
	# @todo find a "Struct" like behaviour to manage local state shape, maybe inner class?
	var connected_door_entity_id = data.get("connected_door_entity_id")
	if not connected_door_entity_id > 0:
		push_warning("invalid door connection ", connected_door_entity_id)
	if p_new_data.get("state") == LeverEntity.LeverState.Activated:
		game_state.patch_entity_data(connected_door_entity_id, {state = ChestStruct.State.Open})
	else:
		game_state.patch_entity_data(connected_door_entity_id, {state = ChestStruct.State.Close})
	
	visual_update_requested.emit(data.get("state"))
