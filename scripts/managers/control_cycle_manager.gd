# @todo should be a singleton?
class_name ControlCycleManager
extends Entity

signal active_target_changed(prev_target: int, new_target: int)

class ControlCycleManagerStruct:
	var puppets: Array[int]
	var default_puppet: int
	var active_puppet: int

	static func from_dict(p_d: Dictionary) -> ControlCycleManagerStruct:
		var x := ControlCycleManagerStruct.new()
		x.puppets = p_d.get("puppets", [])
		x.default_puppet = p_d.get("default_puppet", -1)
		x.active_puppet = p_d.get("active_puppet", -1)
		return x

func _init(p_game_state: GameStateContext, p_puppets: Array[int], p_initial_state: Dictionary) -> void:
	assert(p_puppets.size() > 0, "ControlCycleManager requires at least one puppet")

	var new_state := {
		puppets = p_puppets,
		default_puppet = p_puppets[0],
		active_puppet = p_puppets[0],
	}
	new_state.merge(p_initial_state, true)
	super(p_game_state, new_state)

func wire_signals() -> void:
	game_state.entity_data_changed.connect(on_gs_data_changed)

func get_typed_data() -> ControlCycleManagerStruct:
	var data: Dictionary = game_state.get_entity_data(entity_id)
	return ControlCycleManagerStruct.from_dict(data)

func get_active_target() -> int:
	var data := get_typed_data()

	if data.active_puppet in data.puppets:
		return data.active_puppet

	if data.default_puppet in data.puppets:
		return data.default_puppet

	return -1

func next() -> void:
	var data := get_typed_data()
	if data.puppets.is_empty():
		return

	var current := get_active_target()
	var index := data.puppets.find(current)

	if index == -1:
		set_target(data.default_puppet)
		return

	var next_index := (index + 1) % data.puppets.size()
	set_target(data.puppets[next_index])

func prev() -> void:
	var data := get_typed_data()
	if data.puppets.is_empty():
		return

	var current := get_active_target()
	var index := data.puppets.find(current)

	if index == -1:
		set_target(data.default_puppet)
		return

	var prev_index := posmod(index - 1, data.puppets.size())
	set_target(data.puppets[prev_index])

func set_target(p_target_id: int) -> void:
	var data := get_typed_data()

	if not (p_target_id in data.puppets):
		push_warning("ControlCycleManager.set_target: target is not in puppets: %s" % p_target_id)
		return

	if data.active_puppet == p_target_id:
		return

	game_state.patch_entity_data(entity_id, {
		active_puppet = p_target_id
	})

func on_gs_data_changed(p_entity_id: int, p_new_data: Dictionary, p_prev_data: Dictionary) -> void:
	if p_entity_id != entity_id:
		return

	var prev_target: int = p_prev_data.get("active_puppet", -1)
	var new_target: int = p_new_data.get("active_puppet", -1)

	if prev_target == new_target:
		return

	active_target_changed.emit(prev_target, new_target)
