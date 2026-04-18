class_name ChestEntity
extends Entity

signal visual_update_state_changed(state: ChestStruct.State)
signal visual_update_player_is_nearby(value: bool)

func get_typed_data() -> ChestStruct:
	var data : Dictionary = game_state.get_entity_data(entity_id)
	return ChestStruct.from_dict(data)

# @todo, do we follow golang standard for instance functions, first arg is the self ref?
func on_interact(_from_entity_id: int, to_entity_id: int) -> void:
	if (to_entity_id != entity_id):
		return
	var data := get_typed_data()
	var new_data := {}
	print("pre patch", data)
	if data.state == ChestStruct.State.Open:
		new_data = {state = ChestStruct.State.Close}
	else:
		new_data = {state = ChestStruct.State.Open}
	print("patch to", new_data)
	game_state.patch_entity_data(entity_id, new_data)

# @override
func wire_signals() -> void:
	game_state.entity_data_changed.connect(on_gs_data_changed)
	game_state.tag_changed.connect(on_tag_changed)

func on_gs_data_changed(p_entity_id: int, _p_new_data: Dictionary, _p_prev_data: Dictionary) -> void:
	if (entity_id != p_entity_id):
		return
	var data := get_typed_data()
	visual_update_state_changed.emit(data.state)

func on_tag_changed(tag_name: StringName, source_entity_id:int, _entity_id: int) -> void:
	if tag_name != &"in_player_range":
		return
	var entities_on_tag: Dictionary = game_state.get_entity_tags_by_tag(tag_name)
	if entities_on_tag.is_empty() or entities_on_tag[source_entity_id].is_empty():
		visual_update_player_is_nearby.emit(false)
		return
	# take first for now
	# @todo handle active player, only the active plaer should have focus
	# maybe even better to separate the tag for the indicator?
	if entities_on_tag[source_entity_id].keys()[0] == entity_id:
		visual_update_player_is_nearby.emit(true)
	else:
		visual_update_player_is_nearby.emit(false)
