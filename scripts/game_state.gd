class_name GameState
extends Node

var entities : Dictionary[int, bool] = {}
var entity_nodes : Dictionary[int, WeakRef] = {}
var entity_tags : Dictionary[StringName, Variant]

var next_entity_id : int = 1

signal interact(from_entity_id: int, to_entity_id: int)

func create_entity(node: Node) -> int:
	var entity_id = next_entity_id
	entities[next_entity_id] = true
	entity_nodes[next_entity_id] = weakref(node)

	next_entity_id += 1
	return entity_id

func tag_entity(tag_name: StringName, entity_id: int):
	if not entity_tags.has(tag_name):
		entity_tags[tag_name] = {}
	entity_tags[tag_name][entity_id] = true

func get_entity_tags_by_tag(tag_name: StringName):
	if entity_tags.has(tag_name):
		return entity_tags[tag_name]
	return {}

func untag_entity(tag_name: StringName, entity_id: int):
	if not entity_tags.has(tag_name):
		return
	var tags : Dictionary = entity_tags[tag_name]
	tags.erase(entity_id)

func erase_entity():
	pass

# see if we can even create signals as a wrapper of game state, to keep this pure data
func send_interact(from_entity_id, to_entity_id):
	interact.emit(from_entity_id, to_entity_id)
