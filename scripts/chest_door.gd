extends Node2D


@export var game_state_node : GameState
var game_state : GameStateContext
@onready var chest : Chest = $Chest
@export var entity_id : int
@export var chest_interests : Array[ChestEntity]


func _ready():
	game_state = game_state_node.context
	if entity_id == 0:
		entity_id = game_state.create_entity(self, {state = Chest.ChestState.Close})
	game_state.entity_data_changed.connect(on_gs_data_changed)

func on_gs_data_changed(p_entity_id: int, _new_data):
	var is_interesting = false
	for c in chest_interests:
		if c.entity_id == p_entity_id:
			is_interesting = true
	if not is_interesting:
		return

	# count opened chests
	var open_chest_count = 0
	for c in chest_interests:
		var data = game_state.get_entity_data(c.entity_id)
		if data.get("state") == Chest.ChestState.Open:
			open_chest_count += 1
	
	print("open count ", open_chest_count)
	if open_chest_count >= 3:
		game_state.patch_entity_data(entity_id, { state = Chest.ChestState.Open })
		chest.open()
	else:
		game_state.patch_entity_data(entity_id, { state = Chest.ChestState.Close })
		chest.close()
