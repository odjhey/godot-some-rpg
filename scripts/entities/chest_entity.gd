class_name ChestEntity
extends Entity

enum ChestState {Open, Close}
signal visual_update_state_changed(state: ChestState)
signal visual_update_player_is_nearby(value: bool)

func on_interact(_from_entity_id: int, to_entity_id: int):
	if (to_entity_id == entity_id):
		var data = game_state.get_entity_data(entity_id)
		var new_data = {}
		print("pre patch", data)
		if data.state == Chest.ChestState.Open:
			new_data = {state = Chest.ChestState.Close}
		else:
			new_data = {state = Chest.ChestState.Open}
		print("patch to", new_data)
		game_state.patch_entity_data(entity_id, new_data)

# @override
func wire_signals():
	game_state.entity_data_changed.connect(on_gs_data_changed)
	game_state.tag_changed.connect(on_tag_changed)

func on_gs_data_changed(p_entity_id: int, _p_new_data: Dictionary):
	if (entity_id != p_entity_id):
		return
	var data = game_state.get_entity_data(entity_id)
	visual_update_state_changed.emit(data.get("state"))

func on_tag_changed(tag_name: StringName, _entity_id: int):
	if tag_name != &"in_player_range":
		return
	var entities_on_tag = game_state.get_entity_tags_by_tag(tag_name)
	if not entities_on_tag.is_empty() and entities_on_tag.keys()[0] == entity_id:
		visual_update_player_is_nearby.emit(true)
	else:
		visual_update_player_is_nearby.emit(false)
