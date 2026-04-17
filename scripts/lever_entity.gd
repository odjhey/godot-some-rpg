class_name LeverEntity
extends Node2D

@export var game_state_node : GameState
var game_state : GameStateContext
@export var connected_door : DoorEntity
@onready var interaction_sensor : Area2D = $InteractionSensor
@export var entity_id : int
@export var chest_interests : Array[ChestEntity]
enum LeverState {Deactivated, Activated}


func _ready():
	game_state = game_state_node.context
	if entity_id == 0:
		entity_id = game_state.create_entity(self, {state = LeverState.Deactivated})
	game_state.entity_data_changed.connect(on_gs_data_changed)

	interaction_sensor.area_entered.connect(on_area_entered)
	interaction_sensor.area_exited.connect(on_area_exited)

func on_interact(_from_entity_id: int, to_entity_id: int):
	if to_entity_id != entity_id:
		return
	var data = game_state.get_entity_data(entity_id)
	var new_data = {}
	# toggle
	if data.state == LeverState.Activated:
		new_data = {state = LeverState.Deactivated}
	else:
		new_data = {state = LeverState.Activated}
	game_state.patch_entity_data(entity_id, new_data)

func on_gs_data_changed(p_entity_id: int, p_new_data):
	if p_entity_id != entity_id:
		return
	# toggle connected door state
	if p_new_data.get("state") == LeverState.Activated:
		game_state.patch_entity_data(connected_door.entity_id, {state = Chest.ChestState.Open})
	else:
		game_state.patch_entity_data(connected_door.entity_id, {state = Chest.ChestState.Close})
	# @todo update sprite

func on_area_entered(_area: Area2D):
	# todo find a way to know if its a player
	game_state.tag_entity(&"in_player_range", entity_id)
	print("entered")

func on_area_exited(_area: Area2D):
	# todo find a way to know if its a player
	game_state.untag_entity(&"in_player_range", entity_id)
	print("exited")
