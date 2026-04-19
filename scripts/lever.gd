class_name LeverNode
extends Node2D

@export var game_state_node : GameState
var game_state : GameStateContext
@export var connected_door : Door
@onready var interaction_sensor : Area2D = $InteractionSensor
@export var entity_id : int
var entity: LeverEntity

func _ready() -> void:
	game_state = game_state_node.context
	if entity_id == 0:
		entity = LeverEntity.new(game_state, 
		connected_door.entity_id,
		{
			state = LeverStruct.State.Deactivated,
		})
		entity_id = entity.entity_id

	entity.visual_update_requested.connect(on_visual_update_requested)
	interaction_sensor.area_entered.connect(on_area_entered)
	interaction_sensor.area_exited.connect(on_area_exited)

func on_visual_update_requested(_p_lever_state: int ) -> void:
	print("lever visual update to ", _p_lever_state)

func on_area_entered(area: InteractionTrigger) -> void:
	# todo find a way to know if its a player
	game_state.tag_entity(&"in_player_range", area.source_entity_id, entity_id)
	print("entered ", area.source_entity_id)

func on_area_exited(area: InteractionTrigger) -> void:
	# todo find a way to know if its a player
	game_state.untag_entity(&"in_player_range", area.source_entity_id, entity_id)
	print("exited ", area.source_entity_id)
