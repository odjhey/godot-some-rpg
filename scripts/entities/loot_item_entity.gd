class_name LootItemEntity
extends Entity

func _init(p_game_state: GameStateContext, p_initial_state: Dictionary) -> void:
	var new_state := {}
	new_state.merge(p_initial_state, true)
	super(p_game_state, new_state)

func get_group_instance(p_group_entity_id: int) -> SingleChoiceLootGroupEntity:
	var group := game_state.get_entity_instance(p_group_entity_id) as SingleChoiceLootGroupEntity
	return group

static func set_group(gs: GameStateContext, p_entity_id: int, p_group_id: int) -> void:
	gs.patch_entity_data(p_entity_id, {
		group = p_group_id
	})

func on_interact(_from_entity_id: int, to_entity_id: int) -> void:
	if to_entity_id != entity_id:
		return

	var own_data := game_state.get_entity_data(entity_id)
	var group_id : int = own_data.get("group")
	var group := game_state.get_entity_instance(group_id) as SingleChoiceLootGroupEntity

	if group.can_choose():
		group.set_choice(entity_id)
