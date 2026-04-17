extends GdUnitTestSuite

# levers should open connected doors
func test_door_can_open():
	# arrange
	var gs = GameStateContext.new()
	var default_chest_state = {
		state = ChestEntity.ChestState.Close
		}
	var chest1 = ChestEntity.new(gs, default_chest_state)
	var chest2 = ChestEntity.new(gs, default_chest_state)
	var chest3 = ChestEntity.new(gs, default_chest_state)
	var chest4 = ChestEntity.new(gs, default_chest_state)
	var chest5_not_connected = ChestEntity.new(gs, default_chest_state)
	var chest_door = ChestDoorEntity.new(gs, [
		chest1.entity_id,
		chest2.entity_id,
		chest3.entity_id,
		chest4.entity_id,
		], {
			state = ChestEntity.ChestState.Close
		})

	var dummy_interactor = Entity.new(gs, {})

	# act on unrelated first
	chest5_not_connected.on_interact(dummy_interactor.entity_id, chest5_not_connected.entity_id)
	# assert
	assert_bool(chest_door.is_open()).is_equal(false)

	# act on 2 first
	chest1.on_interact(dummy_interactor.entity_id, chest1.entity_id)
	chest2.on_interact(dummy_interactor.entity_id, chest2.entity_id)
	# assert (not yet)
	assert_bool(chest_door.is_open()).is_equal(false)

	# act on all connected
	chest3.on_interact(dummy_interactor.entity_id, chest3.entity_id)
	chest4.on_interact(dummy_interactor.entity_id, chest4.entity_id)
	# assert (open!)
	assert_bool(chest_door.is_open()).is_equal(true)

	# close the chest
	chest3.on_interact(dummy_interactor.entity_id, chest3.entity_id)
	# assert (closed!)
	assert_bool(chest_door.is_open()).is_equal(false)
