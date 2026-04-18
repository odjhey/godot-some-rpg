extends Node

@export var game_state_node : GameState
var game_state : GameStateContext
var manager : ControlCycleManager
var entity_id : int
@export var puppets : Array[PlayerNode]

const ACTION_FILTER := [
	"move_left",
	"move_right",
	"swap_chars",
	"ui_accept",
	"interact",
]

func _ready() -> void:
	game_state = game_state_node.context
	if entity_id == 0:
		var puppet_ids: Array[int] = []
		for p: PlayerNode in puppets:
			puppet_ids.append(p.entity_id)
		print("puppet_ids ", puppet_ids)
		#@todo could be a singleton?
		manager = ControlCycleManager.new(game_state, puppet_ids, {
			default_target = puppet_ids[0]
			})


func _unhandled_input(event: InputEvent) -> void:
	if not is_valid_action(event):
		return

	if event.is_action_released("swap_chars"):
		manager.next()
		print("next", manager.get_active_target())
		return

	for p in puppets:
		if manager.get_active_target() == p.entity_id:
			p.active_movement = true
		else:
			p.active_movement = false


func is_valid_action(event: InputEvent) -> bool:
	for action: String in ACTION_FILTER:
		if event.is_action_pressed(action):
			return true
		if event.is_action_released("swap_chars"):
			return true
	return false
