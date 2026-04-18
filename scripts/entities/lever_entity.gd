class_name LeverEntity
extends Entity

signal visual_update_requested(state: LeverStruct.State)

func _init(p_game_state: GameStateContext, p_connected_door_entity_id: int, p_initial_state: Dictionary) -> void:
	var new_state := {
		connected_door_entity_id = p_connected_door_entity_id
		}
	new_state.merge(p_initial_state, true)
	super(p_game_state, new_state)

func wire_signals() -> void:
	game_state.entity_data_changed.connect(on_gs_data_changed)

func is_activated() -> bool:
	var data := get_typed_data()
	return data.state == LeverStruct.State.Activated

func on_interact(_from_entity_id: int, to_entity_id: int) -> void:
	if to_entity_id != entity_id:
		return
	var data := get_typed_data()
	var new_data := {}
	# toggle
	if data.state == LeverStruct.State.Activated:
		new_data = {state = LeverStruct.State.Deactivated}
	else:
		new_data = {state = LeverStruct.State.Activated}
	game_state.patch_entity_data(entity_id, new_data)


func on_gs_data_changed(p_entity_id: int, p_new_data: Dictionary) -> void:
	if p_entity_id != entity_id:
		return
	# toggle connected door state
	# @todo cache values on hot paths
	var data := get_typed_data()
	# @todo find a "Struct" like behaviour to manage local state shape, maybe inner class?
	if not data.connected_door_entity_id > 0:
		push_warning("invalid door connection ", data.connected_door_entity_id)
	if p_new_data.get("state") == LeverStruct.State.Activated:
		game_state.patch_entity_data(data.connected_door_entity_id, {state = ChestStruct.State.Open})
	else:
		game_state.patch_entity_data(data.connected_door_entity_id, {state = ChestStruct.State.Close})
	
	visual_update_requested.emit(data.state)

func get_typed_data() -> LeverStruct:
	var data : Dictionary = game_state.get_entity_data(entity_id)
	return LeverStruct.from_dict(data)

