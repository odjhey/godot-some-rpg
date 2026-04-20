class_name LooterComponent
extends BaseComponent

const NAME := &"looter"

var loots : Array[int] = []

func _init() -> void:
	super(NAME)

func add_loot(p_loot_entity_id: int) -> void:
	loots.append(p_loot_entity_id)

func get_loots() -> Array[int]:
	return loots

static func get_c(p_gs: GameStateContext, p_owner_entity_id: int) -> LooterComponent:
	return p_gs.get_component_of_owner(p_owner_entity_id, NAME) as LooterComponent
