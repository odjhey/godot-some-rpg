class_name GameState
extends Node

var context : GameStateContext
var entity_runtime_nodes : Dictionary[int, WeakRef]

func _ready():
	context = GameStateContext.new()

func register_node(p_entity_id: int, p_node: Node):
	entity_runtime_nodes[p_entity_id] = weakref(p_node)

func erase_node(p_entity_id: int):
	entity_runtime_nodes.erase(p_entity_id)

func get_entity_node(p_entity_id: int) -> Node:
	var node = entity_runtime_nodes[p_entity_id].get_ref()
	return node
