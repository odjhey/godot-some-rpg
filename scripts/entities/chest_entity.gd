class_name ChestEntity
extends Entity

var c_activateable :=  ActivateableComponent.new()
var c_openable     :=  OpenableComponent.new()

signal visual_update_state_changed(state: ChestStruct.State)
signal visual_update_player_is_nearby(value: bool)

func _init(p_game_state: GameStateContext, p_initial_state: Dictionary) -> void:

	components = [c_activateable, c_openable]
	super(p_game_state, p_initial_state)

	#c_openable.changed.connect(on_openable_changed)
	c_activateable.changed.connect(on_activateable_changed)

func on_openable_changed() -> void:
	if c_openable.is_open():
		visual_update_state_changed.emit(c_openable.state)
func on_activateable_changed() -> void:
	if c_activateable.is_activated():
		visual_update_state_changed.emit(ChestStruct.State.Open)
	else:
		visual_update_state_changed.emit(ChestStruct.State.Close)

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

	OpenableComponent.get_c(game_state, entity_id).toggle()
	ActivateableComponent.get_c(game_state, entity_id).toggle()

# @override
func wire_signals() -> void:
	game_state.entity_data_changed.connect(on_gs_data_changed)
	game_state.tag_changed.connect(on_tag_changed)

func on_gs_data_changed(p_entity_id: int, _p_new_data: Dictionary, _p_prev_data: Dictionary) -> void:
	return

	if (entity_id != p_entity_id):
		return
	var data := get_typed_data()
	visual_update_state_changed.emit(data.state)

func on_tag_changed(tag_name: StringName, source_entity_id: int, _changed_entity_id: int) -> void:
	if tag_name != &"in_player_range":
		return

	var nearby: Dictionary = game_state.get_entity_tags_by_tag(tag_name).get(source_entity_id, {})

	if nearby.is_empty():
		visual_update_player_is_nearby.emit(false)
		return

	var focused_entity_id: int = nearby.keys()[0]
	visual_update_player_is_nearby.emit(focused_entity_id == entity_id)
