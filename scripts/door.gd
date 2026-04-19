class_name Door
extends Node2D

@export var game_state_node : GameState
var game_state : GameStateContext
@onready var chest : Chest = $Chest
@export var entity_id : int
var entity : DoorEntity

func _ready() -> void:
	game_state = game_state_node.context
	if entity_id == 0:
		entity = DoorEntity.new(game_state, {state = ChestStruct.State.Close})
		entity_id = entity.entity_id
	entity.visual_update_state_changed.connect(on_vizup_state_changed)

func on_vizup_state_changed(state: OpenableComponent.State) -> void:
	if state == OpenableComponent.State.Close:
		chest.close()
	else:
		chest.open()
