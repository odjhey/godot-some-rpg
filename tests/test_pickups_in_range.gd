extends GdUnitTestSuite

func test_smoke_pickup_in_range_pickable() -> void:
	# arrange
	var gs := GameStateContext.new()
	var item := ItemEntity.new(gs, {})
	var player := PlayerEntity.new(gs, {})
	var _player2 := PlayerEntity.new(gs, {})

	var _systems := [AutopickNearbySystem.new(gs)]

	# act
	gs.tag_entity(&"pickable_in_range", player.entity_id, item.entity_id)

	# assert
	# nothing to check for now since moving to inventory component. maybe this is just a smoke test?

	
