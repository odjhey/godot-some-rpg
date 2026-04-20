class_name ActivateableComponent
extends BaseComponent

const NAME := &"activateable"
signal changed

enum State {Deactivated, Activated}
var state : State = State.Deactivated

func _init() -> void:
	super(NAME)

func is_activated() -> bool:
	return state == State.Activated
func activate() -> void:
	state = State.Activated
	changed.emit()
func deactivate() -> void:
	state = State.Deactivated
	changed.emit()
func toggle() -> void:
	if state == State.Activated:
		state = State.Deactivated
	else:
		state = State.Activated
	changed.emit()

static func get_c(p_gs: GameStateContext, p_owner_entity_id: int) -> ActivateableComponent:
	return p_gs.get_component_of_owner(p_owner_entity_id, NAME) as ActivateableComponent
