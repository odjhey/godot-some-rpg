class_name Portal
extends Node2D

@export var game_state_node : GameState
@export var portal_b : Portal
var game_state : GameStateContext
var entity : PortalEntity
var entity_id : int
@onready var interaction_sensor : Area2D = $InteractionSensor

func _ready() -> void:
	game_state = game_state_node.context
	if entity_id == 0:
		entity = PortalEntity.new(game_state, portal_b.entity_id, {})
		entity_id = entity.entity_id
	interaction_sensor.area_entered.connect(on_area_entered)
	interaction_sensor.area_exited.connect(on_area_exited)
	entity.teleport_requested.connect(on_teleport_requested)
	game_state_node.register_node(entity_id, self)

	call_deferred("complete_setup")

func complete_setup() -> void:
	if portal_b != null:
		entity.set_portal_pair(portal_b.entity_id)

func on_area_entered(area: InteractionTrigger) -> void:
	# todo find a way to know if its a player
	game_state.tag_entity(&"in_player_range", area.source_entity_id, entity_id)
	print("entered ", area.source_entity_id)


func on_area_exited(area: InteractionTrigger) -> void:
	# todo find a way to know if its a player
	game_state.untag_entity(&"in_player_range", area.source_entity_id, entity_id)
	print("exited ", area.source_entity_id)

func on_teleport_requested(p_subject: int, p_target: int) -> void:
	var subject_node := game_state_node.get_entity_node(p_subject) as Node2D
	var target_node := game_state_node.get_entity_node(p_target) as Node2D

	if subject_node == null:
		push_warning("Teleport subject node not found: %s" % p_subject)
		return
	if target_node == null:
		push_warning("Teleport target node not found: %s" % p_target)
		return

	subject_node.global_position = target_node.global_position
