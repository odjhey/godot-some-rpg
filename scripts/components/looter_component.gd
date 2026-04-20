class_name LooterComponent
extends BaseComponent

const NAME := &"looter"

func _init() -> void:
	super(NAME)

static func get_c(p_gs: GameStateContext, p_owner_entity_id: int) -> LooterComponent:
	return p_gs.get_component_of_owner(p_owner_entity_id, NAME) as LooterComponent
