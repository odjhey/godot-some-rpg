class_name PortalB
extends Node2D

@export var game_state_node : GameState
@export var portal_a : PortalA
var game_state : GameStateContext
var entity : PortalEntity
var entity_id : int
@onready var interaction_sensor : Area2D = $InteractionSensor

func _ready():
	game_state = game_state_node.context
	if entity_id == 0:
		entity = PortalEntity.new(game_state, portal_a.entity_id, {})
		entity_id = entity.entity_id
	interaction_sensor.area_entered.connect(on_area_entered)
	interaction_sensor.area_exited.connect(on_area_exited)
	entity.teleport_requested.connect(on_teleport_requested)
	game_state_node.register_node(entity_id, self)
	portal_a.entity.set_portal_pair(entity_id)

func on_area_entered(_area: Area2D):
	# todo find a way to know if its a player
	game_state.tag_entity(&"in_player_range", entity_id)
	print("entered")


func on_area_exited(_area: Area2D):
	# todo find a way to know if its a player
	game_state.untag_entity(&"in_player_range", entity_id)
	print("exited")

func on_teleport_requested(p_subject: int, p_target: int):
	var subject_node: Node2D = game_state_node.get_entity_node(p_subject)
	var target_node: Node2D = game_state_node.get_entity_node(p_target)

	print(subject_node.global_position, target_node.global_position)
	subject_node.global_position = target_node.global_position
