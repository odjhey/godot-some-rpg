class_name GameStateContext
extends RefCounted

# @todo, maybe rename from entity_id to runtime_entity_id?
# @todo, consider using a class_name GameRuntime, but currently unclear how to separate

var entities : Dictionary[int, bool] = {}
# @todo, we want to persist this so replace key with global_uid thing
var entity_datas : Dictionary[int, Dictionary]
var entity_instances : Dictionary[int, WeakRef] = {}
var entity_tags : Dictionary[StringName, Dictionary]
var entity_components : Dictionary[StringName, Dictionary] = {}

# this is not serialize->persist->load safe, because we can't control the sequence
# we may need another global_uid type of thing to be safer, like "level1/chest1" or something
var next_entity_id : int = 1

signal entity_data_changed(entity_id: int, new_data: Dictionary, prev_data: Dictionary)
signal tag_changed(tag_name: StringName, source_entity_id: int, entity_id: int)

func create_entity_and_register(p_instance: Entity, p_initial_state: Dictionary = {}) -> int:
	var entity_id := create_entity(p_initial_state)
	register_entity_instance(entity_id, p_instance)
	return entity_id

func create_entity(initial_state: Dictionary = {}) -> int:
	var entity_id := next_entity_id
	entities[entity_id] = true
	entity_datas[entity_id] = initial_state

	next_entity_id += 1
	return entity_id

func get_entity_instance(p_entity_id: int) -> Variant:
	return entity_instances[p_entity_id].get_ref()
func register_entity_instance(p_entity_id: int, p_entity_instance: Variant) -> void:
	entity_instances[p_entity_id] = weakref(p_entity_instance)

# @todo use this in _exit_tree() of nodes
func erase_entity(entity_id: int) -> void:
	entity_instances.erase(entity_id)
	entities.erase(entity_id)
	for tag_name: StringName in entity_tags.keys():
		entity_tags[tag_name].erase(entity_id)

# @todo, is this final? do all tags require a source_entity_id? do we need to change this to entity_relations instead?
func tag_entity(tag_name: StringName, source_entity_id: int, entity_id: int) -> void:
	if not entity_tags.has(tag_name):
		entity_tags[tag_name] = {}
	if not entity_tags[tag_name].has(source_entity_id):
		entity_tags[tag_name][source_entity_id] = {}

	entity_tags[tag_name][source_entity_id][entity_id] = true
	tag_changed.emit(tag_name, source_entity_id, entity_id)

func get_entity_tags_by_tag(tag_name: StringName) -> Dictionary:
	if entity_tags.has(tag_name):
		return entity_tags[tag_name]
	return {}

func register_entity_components(owner_entity_id: int, component: BaseComponent) -> void:
	if not entity_components.has(component.component_name):
		entity_components[component.component_name] = {}
	entity_components[component.component_name][owner_entity_id] = component
func get_component_of_owner(p_owner_entity_id: int, p_component_name: StringName) -> BaseComponent:
	if not entity_components.has(p_component_name):
		return null
	var c := entity_components[p_component_name][p_owner_entity_id] as BaseComponent
	if c != null:
		return c
	return null


func untag_entity(tag_name: StringName, source_entity_id:int, entity_id: int) -> void:
	if not entity_tags.has(tag_name):
		return
	if not entity_tags[tag_name].has(source_entity_id):
		return
	var tags : Dictionary = entity_tags[tag_name][source_entity_id]
	tags.erase(entity_id)
	tag_changed.emit(tag_name, source_entity_id, entity_id)

# see if we can even create signals as a wrapper of game state, to keep this pure data
# this should be extracted, as this i think is not needed to be "serialized" for saving and thus should not be in the game_state? but then again, &"in_range" is not needed to be saved tho, hmmm
func send_interact(from_entity_id: int, to_entity_id: int) -> void:
	var instance_ref := entity_instances[to_entity_id]
	var instance: Entity = instance_ref.get_ref()
	if instance:
		instance.on_interact(from_entity_id, to_entity_id)

func get_entity_data(entity_id: int) -> Dictionary:
	return entity_datas[entity_id]
	
func patch_entity_data(p_entity_id: int, new_kvs: Dictionary) -> void:
	var data: Dictionary = entity_datas[p_entity_id]
	var prev_data := data.duplicate(true)
	for k: StringName in new_kvs:
		data[k] = new_kvs[k]
	entity_data_changed.emit(p_entity_id, data, prev_data)
