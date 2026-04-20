class_name LeverNode
extends Node2D

@export var game_state_node : GameState
var game_state : GameStateContext
@onready var interaction_sensor : Area2D = $InteractionSensor
@export var entity_id : int
var entity: LeverEntity

func _ready() -> void:
	game_state = game_state_node.context
	if entity_id == 0:
		entity = LeverEntity.new(game_state, ActivateableComponent.State.Deactivated)
		entity_id = entity.entity_id

	interaction_sensor.area_entered.connect(on_area_entered)
	interaction_sensor.area_exited.connect(on_area_exited)

func on_area_entered(area: InteractionTrigger) -> void:
	# todo find a way to know if its a player
	game_state.tag_entity(&"in_player_range", area.source_entity_id, entity_id)
	print("entered ", area.source_entity_id)

func on_area_exited(area: InteractionTrigger) -> void:
	# todo find a way to know if its a player
	game_state.untag_entity(&"in_player_range", area.source_entity_id, entity_id)
	print("exited ", area.source_entity_id)
