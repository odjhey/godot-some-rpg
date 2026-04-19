class_name ChestDoorNode
extends Node2D


@export var game_state_node : GameState
var game_state : GameStateContext
@onready var chest : Chest = $Chest
@export var entity_id : int
@export var chest_interests : Array[ChestNode]
var entity: ChestDoorEntity

func _ready() -> void:
	game_state = game_state_node.context
	if entity_id == 0:
		var cids: Array[int] = []
		for c in chest_interests:
			cids.append(c.entity_id)
		entity = ChestDoorEntity.new(game_state, cids, {
			state = ChestStruct.State.Close
			})
		entity_id = entity.entity_id
	
	entity.visual_update_requested.connect(on_vizup_state_changed)

func on_vizup_state_changed(state: ChestStruct.State) -> void:
	if state == ChestStruct.State.Open:
		chest.open()
	else:
		chest.close()
