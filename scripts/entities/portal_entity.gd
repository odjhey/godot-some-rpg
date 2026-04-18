class_name PortalEntity
extends Entity


signal teleport_requested(subject_id: int, target_id: int)

func _init(p_game_state: GameStateContext, 
p_pair_portal_id: int,
p_initial_state: Dictionary) -> void:
	var new_state := {
		pair_portal_id = p_pair_portal_id
		}
	new_state.merge(p_initial_state, true)
	super(p_game_state, new_state)

func set_portal_pair(p_portal_pair_entity_id: int) -> void:
	game_state.patch_entity_data(entity_id, {pair_portal_id = p_portal_pair_entity_id})

func on_interact(from_entity_id: int, to_entity_id: int) -> void:
	if (to_entity_id != entity_id):
		return
	var data := game_state.get_entity_data(entity_id)
	var pair_portal_id : int = data.get("pair_portal_id")
	print("emit", from_entity_id, pair_portal_id)
	teleport_requested.emit(from_entity_id, pair_portal_id)
