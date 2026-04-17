extends Node2D

@export var game_state_node : GameState
var game_state : GameStateContext
@export var connected_door : Door
@onready var interaction_sensor : Area2D = $InteractionSensor
@export var entity_id : int
var entity: LeverEntity
@export var chest_interests : Array[ChestEntity]

func _ready():
	game_state = game_state_node.context
	if entity_id == 0:
		entity = LeverEntity.new(game_state, 
		connected_door.entity_id,
		{
			state = LeverEntity.LeverState.Deactivated,
		})
		entity_id = entity.entity_id
		game_state.register_entity(entity_id, self)

	entity.visual_update_requested.connect(on_visual_update_requested)
	interaction_sensor.area_entered.connect(on_area_entered)
	interaction_sensor.area_exited.connect(on_area_exited)

func on_interact(...args):
	entity.callv("on_interact", args)

func on_visual_update_requested(_p_lever_state: int ):
	print("lever visual update to ", _p_lever_state)

func on_area_entered(_area: Area2D):
	# todo find a way to know if its a player
	game_state.tag_entity(&"in_player_range", entity_id)
	print("entered")

func on_area_exited(_area: Area2D):
	# todo find a way to know if its a player
	game_state.untag_entity(&"in_player_range", entity_id)
	print("exited")
