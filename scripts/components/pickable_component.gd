class_name PickableComponent
extends BaseComponent

const NAME := &"pickable"
func _init() -> void:
	super(NAME)

static func get_c(p_gs: GameStateContext, p_owner_entity_id: int) -> PickableComponent:
	return p_gs.get_component_of_owner(p_owner_entity_id, NAME) as PickableComponent
