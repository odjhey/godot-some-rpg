class_name DoorEntity
extends Node2D

@export var game_state_node : GameState
var game_state : GameStateContext
@onready var chest : Chest = $Chest
@export var entity_id : int

func _ready():
	game_state = game_state_node.context
	if entity_id == 0:
		entity_id = game_state.create_entity_and_register(self, {state = Chest.ChestState.Close})
	game_state.entity_data_changed.connect(on_gs_data_changed)

func on_gs_data_changed(p_entity_id: int, p_new_data):
	if p_entity_id != entity_id:
		return
	
	if p_new_data.get("state") == Chest.ChestState.Close:
		chest.close()
	else:
		chest.open()
