class_name Entity
extends RefCounted

var entity_id: int
var game_state: GameStateContext
var components: Array[BaseComponent] = []

func _init(p_game_state: GameStateContext, p_initial_state: Dictionary) -> void:
	game_state = p_game_state
	entity_id = p_game_state.create_entity_and_register(self, p_initial_state.duplicate())
	register_components()
	wire_signals()

# @todo how to unregister? or just deactivate?
func register_components() -> void:
	for c in components:
		game_state.register_entity_components(entity_id, c)

func wire_signals() -> void:
	pass

# @todo see if we can use composition for interactable_entities
func on_interact(_from_entity_id: int, to_entity_id: int) -> void:
	if (to_entity_id != entity_id):
		return
	push_warning("Interacting on something that is not interactable: [entity_id]=", entity_id)
