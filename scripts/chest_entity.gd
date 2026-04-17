class_name ChestEntity
extends Node2D

@export var entity_id : int
@export var game_state : GameState
@onready var interaction_sensor : Area2D = $InteractionSensor
@onready var interaction_hint : Label = $InteractionHint
@onready var chest: Chest = $Chest

func _ready():
	# create game state entity
	if entity_id == 0:
		entity_id = game_state.create_entity(self, { state = Chest.ChestState.Close })
	
	game_state.entity_data_changed.connect(on_gs_data_changed)
	game_state.tag_changed.connect(on_tag_changed)
	interaction_sensor.area_entered.connect(on_area_entered)
	interaction_sensor.area_exited.connect(on_area_exited)

func on_interact(_from_entity_id: int, to_entity_id: int):
	if (to_entity_id == entity_id):
		var data = game_state.get_entity_data(entity_id)
		var new_data = {}
		print("pre patch", data)
		if data.state == Chest.ChestState.Open:
			new_data = {state = Chest.ChestState.Close}
		else:
			new_data = {state = Chest.ChestState.Open}
		print("patch to", new_data)
		game_state.patch_entity_data(entity_id, new_data)

# @todo rename use of _ here
func on_gs_data_changed(_entity_id: int, new_data: Dictionary):
	if (entity_id != _entity_id):
		return
	if new_data.state == Chest.ChestState.Open:
		chest.open()
	else:
		chest.close()
func on_tag_changed(tag_name: StringName, _entity_id: int):
	if tag_name != &"in_player_range":
		return
	var entities_on_tag = game_state.get_entity_tags_by_tag(tag_name)
	if not entities_on_tag.is_empty() and entities_on_tag.keys()[0] == entity_id:
		interaction_hint.visible = true
	else:
		interaction_hint.visible = false

func on_area_entered(_area: Area2D):
	# todo find a way to know if its a player
	game_state.tag_entity(&"in_player_range", entity_id)
	print("entered")


func on_area_exited(_area: Area2D):
	# todo find a way to know if its a player
	game_state.untag_entity(&"in_player_range", entity_id)
	print("exited")
