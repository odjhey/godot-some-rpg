class_name SingleChoiceLootGroupEntity
extends Entity


func _init(p_game_state: GameStateContext, p_loots: Array[int], p_initial_state: Dictionary):
	var new_state = {
		loots = p_loots,
		can_choose = true,
		choice = null
		}
	new_state.merge(p_initial_state, true)
	super(p_game_state, new_state)

func can_choose() -> bool:
	var data = game_state.get_entity_data(entity_id)
	return data.get("can_choose")

func chosen_id() -> int:
	var data = game_state.get_entity_data(entity_id)
	return data.get("choice")

func set_choice(p_entity_id: int) -> void:
	if not can_choose():
		return
	var data = game_state.get_entity_data(entity_id)
	var loots = data.get("loots") as Array[int]
	if not loots.has(p_entity_id):
		return

	var patched_data = {
		can_choose = false,
		choice = p_entity_id
		}

	game_state.patch_entity_data(entity_id, patched_data)
