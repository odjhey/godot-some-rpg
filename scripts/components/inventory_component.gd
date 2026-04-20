class_name InventoryComponent
extends BaseComponent

const NAME := &"inventory"
var contents: Array[int] = []

func _init() -> void:
	super(NAME)

func add_item(p_item_entity_id: int) -> void:
	contents.append(p_item_entity_id)

func get_contents() -> Array[int]:
	return contents

static func get_c(p_gs: GameStateContext, p_owner_entity_id: int) -> InventoryComponent:
	return p_gs.get_component_of_owner(p_owner_entity_id, NAME) as InventoryComponent
