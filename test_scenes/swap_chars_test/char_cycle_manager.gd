class_name PuppetController
extends Node

@export var game_state_node: GameState
@export var puppets: Array[PlayerNode]

var game_state: GameStateContext
var manager: ControlCycleManager
var entity_id: int

const ACTION_SWAP: StringName = &"swap_chars"
const ACTION_LEFT: StringName = &"move_left"
const ACTION_RIGHT: StringName = &"move_right"
const ACTION_JUMP: StringName = &"ui_accept"
const ACTION_INTERACT: StringName = &"interact"
const ACTION_BLINK: StringName = &"blink_skill"
const ACTION_INVENTORY: StringName = &"inventory"

func _ready() -> void:
	game_state = game_state_node.context

	if entity_id == 0:
		var puppet_ids: Array[int] = []
		for p: PlayerNode in puppets:
			puppet_ids.append(p.entity_id)

		manager = ControlCycleManager.new(game_state, puppet_ids, {
			active_puppet = puppet_ids[0],
			default_puppet = puppet_ids[0],
		})

	manager.active_target_changed.connect(on_active_target_changed)
	on_active_target_changed(-1, manager.get_active_target())

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released(ACTION_SWAP):
		manager.next()
		return

	var active := get_active_puppet()
	if active == null:
		return

	if event.is_action_pressed(ACTION_JUMP):
		active.request_jump()
	if event.is_action_pressed(ACTION_BLINK):
		active.request_blink()

	if event.is_action_released(ACTION_INTERACT):
		active.request_interact()
	if event.is_action_released(ACTION_INVENTORY):
		active.request_inventory()

func _physics_process(_delta: float) -> void:
	var active := get_active_puppet()
	if active == null:
		return

	var move_x := Input.get_axis(ACTION_LEFT, ACTION_RIGHT)
	active.set_move_input(move_x)

func get_active_puppet() -> PlayerNode:
	var active_id := manager.get_active_target()
	for p: PlayerNode in puppets:
		if p.entity_id == active_id:
			return p
	return null

func on_active_target_changed(_prev_target: int, new_target: int) -> void:
	for p: PlayerNode in puppets:
		p.set_is_controlled(p.entity_id == new_target)
