class_name ChestNode
extends Node2D

@export var entity_id : int
@export var game_state_node : GameState
var game_state : GameStateContext
@onready var interaction_sensor : Area2D = $InteractionSensor
@onready var interaction_hint : Label = $InteractionHint
@onready var chest: Chest = $Chest

var entity: ChestEntity

func _ready():
	game_state = game_state_node.context
	# create game state entity
	if entity_id == 0:
		entity = ChestEntity.new(game_state, { state = Chest.ChestState.Close })
		entity_id = entity.entity_id
	
	interaction_sensor.area_entered.connect(on_area_entered)
	interaction_sensor.area_exited.connect(on_area_exited)

	entity.visual_update_state_changed.connect(on_vizup_state_changed)
	entity.visual_update_player_is_nearby.connect(on_vizup_player_is_nearby)

func on_vizup_state_changed(p_state: ChestEntity.ChestState):
	if p_state == ChestEntity.ChestState.Open:
		chest.open()
	else:
		chest.close()

func on_vizup_player_is_nearby(p_is_nearby: bool):
	interaction_hint.visible = p_is_nearby

func on_area_entered(_area: Area2D):
	# todo find a way to know if its a player
	game_state.tag_entity(&"in_player_range", entity_id)
	print("entered")


func on_area_exited(_area: Area2D):
	# todo find a way to know if its a player
	game_state.untag_entity(&"in_player_range", entity_id)
	print("exited")
