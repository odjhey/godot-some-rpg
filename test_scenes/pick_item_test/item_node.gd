class_name ItemNode
extends Node2D

@export var entity_id : int
@export var game_state_node : GameState
var game_state : GameStateContext
@onready var pickable_sensor : Area2D = $PickableSensor
@onready var animation : AnimationPlayer = $AnimationPlayer

var entity: ItemEntity

func _ready() -> void:
	game_state = game_state_node.context
	# create game state entity
	if entity_id == 0:
		entity = ItemEntity.new(game_state, {})
		entity_id = entity.entity_id
	pickable_sensor.area_entered.connect(on_area_entered)
	pickable_sensor.area_exited.connect(on_area_exited)
	game_state_node.register_node(entity_id, self)

func on_area_entered(area: InteractionTrigger) -> void:
	# todo find a way to know if its a player
	game_state.tag_entity(&"pickable_in_range", area.source_entity_id, entity_id)
	print("pickable_in_range entered", area.source_entity_id)


func on_area_exited(area: InteractionTrigger) -> void:
	# todo find a way to know if its a player
	game_state.untag_entity(&"pickable_in_range", area.source_entity_id, entity_id)
	print("pickable_in_range exited", area.source_entity_id)

func animate_and_free() -> void:
	animation.play("exit")
	await animation.animation_finished
	queue_free()
