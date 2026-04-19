class_name LeverStruct
extends RefCounted

# @todo if we move to using components for behaviours, do we still need this?

enum State {Deactivated, Activated}
var state : State
var connected_door_entity_id: int

static func from_dict(p_d: Dictionary) -> LeverStruct:
	var x := LeverStruct.new()
	x.state = p_d.get("state", State.Deactivated)
	x.connected_door_entity_id = p_d.get("connected_door_entity_id")

	return x

func to_dict() -> Dictionary:
	return {
		state = state
		}
