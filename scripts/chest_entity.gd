extends Node2D

@export var entity_id : int
@export var game_state : GameState
@onready var interaction_sensor : Area2D = $InteractionSensor
@onready var chest: Chest = $Chest

func _ready():
	# create game state entity
	if entity_id == 0:
		entity_id = game_state.create_entity(self)
	
	interaction_sensor.area_entered.connect(on_area_entered)
	interaction_sensor.area_exited.connect(on_area_exited)
	game_state.interact.connect(on_interact)

func on_interact(from_entity_id: int, to_entity_id: int):
	if (to_entity_id == entity_id):
		if chest.state == Chest.ChestState.Open:
			chest.close()
		else:
			chest.open()

func on_area_entered(area: Area2D):
	# todo find a way to know if its a player
	game_state.tag_entity(&"in_player_range", entity_id)
	print("entered")


func on_area_exited(area: Area2D):
	# todo find a way to know if its a player
	game_state.untag_entity(&"in_player_range", entity_id)
	print("exited")
