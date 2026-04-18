extends GdUnitTestSuite

# levers should open connected doors
func test_is_activated() -> void:
	# arrange
	var gs := GameStateContext.new()
	var door := DoorEntity.new(gs, {
		state = ChestStruct.State.Close
		})
	var lever := LeverEntity.new(gs, door.entity_id, {
		state = LeverStruct.State.Deactivated
		})
	var player := PlayerEntity.new(gs, {})

	# act
	player.interact(gs, lever.entity_id)

	# assert
	assert_bool(door.is_open()).is_equal(true)
	assert_bool(lever.is_activated()).is_equal(true)

	# act
	player.interact(gs, lever.entity_id)

	# assert
	assert_bool(door.is_open()).is_equal(false)
	assert_bool(lever.is_activated()).is_equal(false)
