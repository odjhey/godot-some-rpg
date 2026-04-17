extends GdUnitTestSuite

# levers should open connected doors
func test_is_activated():
	# arrange
	var gs = GameStateContext.new()
	var door = DoorEntity.new(gs, {
		state = Chest.ChestState.Close
		})
	var lever = LeverEntity.new(gs, door.entity_id, {
		state = LeverEntity.LeverState.Deactivated
		})
	var dummy_interactor = Entity.new(gs, {})

	# act
	lever.on_interact(dummy_interactor.entity_id, lever.entity_id)

	# assert
	assert_bool(door.is_open()).is_equal(true)
	assert_bool(lever.is_activated()).is_equal(true)

	# act
	lever.on_interact(dummy_interactor.entity_id, lever.entity_id)

	# assert
	assert_bool(door.is_open()).is_equal(false)
	assert_bool(lever.is_activated()).is_equal(false)
