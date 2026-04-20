class_name PlayerNode
extends CharacterBody2D

const JUMP_VELOCITY := -1500.0
const SPEED := 300.0

# @todos
# - add dash or blink
# - add run increase speed, means jump farther if enough speed
# - doubl jumps?

@export var game_state_node: GameState
@onready var interaction_trigger : InteractionTrigger = $InteractionTrigger

var game_state: GameStateContext
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity") * 2.0
var weight := 2.0

var entity_id: int
var entity: PlayerEntity

var is_controlled := false
var move_input_x := 0.0
var jump_requested := false
var blink_requested := false
var interact_requested := false
var direction := Vector2.RIGHT

func _ready() -> void:
	game_state = game_state_node.context

	if entity_id == 0:
		entity = PlayerEntity.new(game_state, {})
		entity_id = entity.entity_id

	interaction_trigger.source_entity_id = entity_id
	game_state_node.register_node(entity_id, self)

func set_is_controlled(value: bool) -> void:
	is_controlled = value
	if not is_controlled:
		move_input_x = 0.0

func set_move_input(p_x: float) -> void:
	move_input_x = p_x

func request_jump() -> void:
	jump_requested = true

func request_blink() -> void:
	blink_requested = true

func request_interact() -> void:
	interact_requested = true

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * weight * delta

func apply_horizontal_movement() -> void:
	velocity.x = move_input_x * SPEED

func handle_jump() -> void:
	if jump_requested and is_on_floor():
		velocity.y = JUMP_VELOCITY
	jump_requested = false
func handle_blink() -> void:
	if blink_requested:
		position.x += 300
	blink_requested = false

func handle_interact() -> void:
	if not interact_requested:
		return

	interact_requested = false

	var in_range: Dictionary = game_state.get_entity_tags_by_tag(&"in_player_range")
	if not in_range.has(entity_id):
		return

	var nearby: Dictionary = in_range[entity_id]
	if nearby.is_empty():
		return

	var target_id: int = nearby.keys()[0]
	interact(target_id)

func _physics_process(delta: float) -> void:
	apply_gravity(delta)

	if is_controlled:
		apply_horizontal_movement()
		handle_jump()
		handle_interact()
		handle_blink()
	else:
		velocity.x = 0.0

	move_and_slide()

func interact(p_entity_id: int) -> void:
	print("interact with ", p_entity_id)
	game_state.send_interact(entity_id, p_entity_id)
