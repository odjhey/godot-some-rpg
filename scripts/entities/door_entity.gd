class_name DoorEntity
extends Entity

func is_open() -> bool:
	var data := game_state.get_entity_data(entity_id)
	return data.get("state") == ChestStruct.State.Open


