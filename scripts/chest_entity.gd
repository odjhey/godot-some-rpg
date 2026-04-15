extends Node2D

@export var entity_id : int
@export var game_state : GameState
@onready var interaction_sensor : Area2D = $InteractionSensor
@onready var chest: Chest = $Chest

func _ready():
	# create game state entity
	if entity_id == 0:
		entity_id = game_state.create_entity(self, { state = Chest.ChestState.Close })
	
	game_state.data_change.connect(on_gs_data_change)
	interaction_sensor.area_entered.connect(on_area_entered)
	interaction_sensor.area_exited.connect(on_area_exited)

func on_interact(from_entity_id: int, to_entity_id: int):
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

func on_gs_data_change(_entity_id: int, new_data: Dictionary):
	if (entity_id == _entity_id):
		print("----- on_gs_change", new_data)
		if new_data.state == Chest.ChestState.Open:
			chest.open()
		else:
			chest.close()

func on_area_entered(area: Area2D):
	# todo find a way to know if its a player
	game_state.tag_entity(&"in_player_range", entity_id)
	print("entered")


func on_area_exited(area: Area2D):
	# todo find a way to know if its a player
	game_state.untag_entity(&"in_player_range", entity_id)
	print("exited")
