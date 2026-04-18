# @todo should be a singleton?
# @todo should be a singleton?
class_name ControlCycleManager
extends Entity

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

func get_typed_data() -> ControlCycleManagerStruct:
	var data: Dictionary = game_state.get_entity_data(entity_id)
	return ControlCycleManagerStruct.from_dict(data)

func _init(p_game_state: GameStateContext, p_puppets: Array[int], p_initial_state: Dictionary) -> void:
	assert(p_puppets.size() > 0, "ControlCycleManager requires at least one puppet")

	var new_state := {
		puppets = p_puppets,
		default_puppet = p_puppets[0],
		active_puppet = p_puppets[0],
	}
	new_state.merge(p_initial_state, true)
	super(p_game_state, new_state)

func get_active_target() -> int:
	var own_data := get_typed_data()

	if own_data.active_puppet in own_data.puppets:
		return own_data.active_puppet

	if own_data.default_puppet in own_data.puppets:
		return own_data.default_puppet

	return -1

func next() -> void:
	var own_data := get_typed_data()
	if own_data.puppets.is_empty():
		return

	var current := get_active_target()
	var current_index := own_data.puppets.find(current)

	if current_index == -1:
		set_target(own_data.default_puppet)
		return

	var next_index := (current_index + 1) % own_data.puppets.size()
	set_target(own_data.puppets[next_index])

func prev() -> void:
	var own_data := get_typed_data()
	if own_data.puppets.is_empty():
		return

	var current := get_active_target()
	var current_index := own_data.puppets.find(current)

	if current_index == -1:
		set_target(own_data.default_puppet)
		return

	var prev_index := posmod(current_index - 1, own_data.puppets.size())
	set_target(own_data.puppets[prev_index])

func set_target(p_target_id: int) -> void:
	var own_data := get_typed_data()
	if not (p_target_id in own_data.puppets):
		push_warning("ControlCycleManager.set_target: target is not in puppets: %s" % p_target_id)
		return

	game_state.patch_entity_data(entity_id, {
		active_puppet = p_target_id
	})
