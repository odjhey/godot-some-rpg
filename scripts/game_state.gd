class_name GameState
extends Node

var entities : Dictionary[int, bool] = {}
# @todo, we want to persist this so replace key with global_uid thing
var entity_datas : Dictionary[int, Dictionary]
var entity_nodes : Dictionary[int, WeakRef] = {}
var entity_tags : Dictionary[StringName, Dictionary]

# this is not serialize->persist->load safe, because we can't control the sequence
# we may need another global_uid type of thing to be safer, like "level1/chest1" or something
var next_entity_id : int = 1

# @todod rename to *changed
signal entity_data_changed(entity_id: int, new_data: Dictionary)
signal tag_changed(tag_name: StringName, entity_id: int)

func create_entity(node: Node, initial_state: Dictionary = {}) -> int:
	var entity_id = next_entity_id
	entities[entity_id] = true
	entity_nodes[entity_id] = weakref(node)
	entity_datas[entity_id] = initial_state

	next_entity_id += 1
	return entity_id

# @todo use this in _exit_tree() of nodes
func erase_entity(entity_id: int):
	entity_nodes.erase(entity_id)
	entities.erase(entity_id)
	for tag_name in entity_tags.keys():
		entity_tags[tag_name].erase(entity_id)

# @todo, for relationships like &"in_range", we may want the player to own so entity_tags[tag_name][player][entity_id] = { data }
func tag_entity(tag_name: StringName, entity_id: int):
	if not entity_tags.has(tag_name):
		entity_tags[tag_name] = {}
	entity_tags[tag_name][entity_id] = true
	tag_changed.emit(tag_name, entity_id)

func get_entity_tags_by_tag(tag_name: StringName):
	if entity_tags.has(tag_name):
		return entity_tags[tag_name]
	return {}

func untag_entity(tag_name: StringName, entity_id: int):
	if not entity_tags.has(tag_name):
		return
	var tags : Dictionary = entity_tags[tag_name]
	tags.erase(entity_id)
	tag_changed.emit(tag_name, entity_id)

# see if we can even create signals as a wrapper of game state, to keep this pure data
# this should be extracted, as this i think is not needed to be "serialized" for saving and thus should not be in the game_state? but then again, &"in_range" is not needed to be saved tho, hmmm
func send_interact(from_entity_id, to_entity_id):
	var node_ref = entity_nodes[to_entity_id]
	if node_ref == null:
		return
	var node: Node = node_ref.get_ref()
	if node and node.has_method("on_interact"):
		node.on_interact(from_entity_id, to_entity_id)

func get_entity_data(entity_id: int):
	return entity_datas[entity_id]
	
func patch_entity_data(entity_id, new_kvs: Dictionary):
	var data: Dictionary = entity_datas[entity_id]
	for k in new_kvs:
		data[k] = new_kvs[k]
	entity_data_changed.emit(entity_id, data)
