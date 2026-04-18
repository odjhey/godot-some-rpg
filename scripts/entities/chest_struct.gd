class_name ChestStruct
extends RefCounted

enum State {Open, Close}
var state : State

static func from_dict(p_d: Dictionary) -> ChestStruct:
	var x := ChestStruct.new()
	x.state = p_d.get("state", State.Close)

	return x


func to_dict() -> Dictionary:
	return {
		state = state
		}
