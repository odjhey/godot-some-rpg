class_name OpenableComponent
extends BaseComponent

const NAME := &"openable"
signal changed

enum State {Open, Close}
var state : State = State.Close

func _init() -> void:
	super(NAME)

func is_open() -> bool:
	return state == State.Open
func open() -> void:
	state = State.Open
	changed.emit()
func close() -> void:
	state = State.Close
	changed.emit()

static func get_c(p_gs: GameStateContext, p_owner_entity_id: int) -> OpenableComponent:
	return p_gs.get_component_of_owner(p_owner_entity_id, NAME) as OpenableComponent
