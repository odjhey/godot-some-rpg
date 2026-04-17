class_name ChestDoorEntity
extends Entity

signal visual_update_requested(state: ChestEntity.ChestState)

func _init(p_game_state: GameStateContext, p_connected_chests_entity_ids: Array[int], p_initial_state: Dictionary):
	var new_state = {
		connected_chests_entity_ids = p_connected_chests_entity_ids
		}
	new_state.merge(p_initial_state, true)
	super(p_game_state, new_state)

func wire_signals():
	game_state.entity_data_changed.connect(on_gs_data_changed)

func is_open() -> bool:
	var own_data = game_state.get_entity_data(entity_id)
	return own_data.get("state") == ChestEntity.ChestState.Open

func on_gs_data_changed(p_entity_id: int, _new_data):
	var own_data = game_state.get_entity_data(entity_id)
	var connected_chest_ids: Array[int] = own_data.get("connected_chests_entity_ids")

	var is_chest_connected = false
	for cid in connected_chest_ids:
		if cid == p_entity_id:
			is_chest_connected = true
	if not is_chest_connected:
		return

	# count opened chests
	var open_chest_count = 0
	for cid in connected_chest_ids:
		var c_data = game_state.get_entity_data(cid)
		if c_data.get("state") == ChestEntity.ChestState.Open:
			open_chest_count += 1
	
	if open_chest_count >= connected_chest_ids.size():
		game_state.patch_entity_data(entity_id, { state = ChestEntity.ChestState.Open })
		visual_update_requested.emit(ChestEntity.ChestState.Open)
	else:
		game_state.patch_entity_data(entity_id, { state = ChestEntity.ChestState.Close })
		visual_update_requested.emit(ChestEntity.ChestState.Close)
