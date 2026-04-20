# @todo do we continue using the suffix Entity if it contains not just entity_id?
class_name ItemEntity
extends Entity

var c_pickable := PickableComponent.new()

func _init(p_game_state: GameStateContext, p_initial_state: Dictionary) -> void:
	components = [c_pickable]
	super(p_game_state, p_initial_state)
