extends CharacterBody2D

const JUMP_VELOCITY = -500.0
const SPEED = 300

@export var game_state : GameState
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var weight := 2
var entity_id : int


func _ready():
	# create game state entity
	if entity_id == 0:
		entity_id = game_state.create_entity(self)

func apply_gravity(delta, _velocity: Vector2, is_grounded: bool) -> Vector2:
	if not is_grounded:
		_velocity.y += gravity * weight * delta
	
	return _velocity


func _physics_process(delta):
	velocity = apply_gravity(delta, velocity, is_on_floor())
	# handle jump
	if Input.is_action_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_released("interact"):
		var in_range = game_state.get_entity_tags_by_tag(&"in_player_range")
		if not in_range.is_empty():
			# take the first one that we made contact with
			var interact_with_entity_id = in_range.keys()[0]
			interact(interact_with_entity_id)

	# left right
	var direction := Input.get_axis("move_left", "move_right")
	velocity.x = direction * SPEED

	move_and_slide()

func interact(_entity_id: int):
	print("interact with ", _entity_id)
	game_state.send_interact(entity_id, _entity_id)
