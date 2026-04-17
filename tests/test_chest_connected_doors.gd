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

	var player = PlayerEntity.new(gs,{})

	# act on unrelated first
	player.interact(gs, chest5_not_connected.entity_id)
	# assert
	assert_bool(chest_door.is_open()).is_equal(false)

	# act on 2 first
	player.interact(gs, chest1.entity_id)
	player.interact(gs, chest2.entity_id)
	# assert (not yet)
	assert_bool(chest_door.is_open()).is_equal(false)

	# act on all connected
	player.interact(gs, chest3.entity_id)
	player.interact(gs, chest4.entity_id)
	# assert (open!)
	assert_bool(chest_door.is_open()).is_equal(true)

	# close the chest
	player.interact(gs, chest3.entity_id)
	# assert (closed!)
	assert_bool(chest_door.is_open()).is_equal(false)
