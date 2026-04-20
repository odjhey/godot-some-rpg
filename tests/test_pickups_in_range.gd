extends GdUnitTestSuite

func test_pickup_in_range_pickable() -> void:
	# arrange
	var gs := GameStateContext.new()
	var item := ItemEntity.new(gs, {})
	var player := PlayerEntity.new(gs, {})
	var player2 := PlayerEntity.new(gs, {})

	var systems := [AutopickNearbySystem.new(gs, [
		LooterComponent.get_c(gs, player.entity_id),
		LooterComponent.get_c(gs, player2.entity_id),
		])]

	# act
	gs.tag_entity(&"pickable_in_range", player.entity_id, item.entity_id)

	# assert
	var loots1 := LooterComponent.get_c(gs, player.entity_id).get_loots()
	assert_array(loots1).is_equal([item.entity_id])

	var loots2 := LooterComponent.get_c(gs, player2.entity_id).get_loots()
	assert_array(loots2).is_equal([])

	
