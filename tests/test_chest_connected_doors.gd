extends GdUnitTestSuite

# levers should open connected doors
func test_door_can_open() -> void:
	# arrange
	var gs := GameStateContext.new()
	var default_chest_state := {
		state = ChestStruct.State.Close
		}
	var chest1 := ChestEntity.new(gs, default_chest_state)
	var chest2 := ChestEntity.new(gs, default_chest_state)
	var chest3 := ChestEntity.new(gs, default_chest_state)
	var chest4 := ChestEntity.new(gs, default_chest_state)
	var chest5_not_connected := ChestEntity.new(gs, default_chest_state)
	var chest_door := ChestDoorEntity.new(gs, [
		chest1.entity_id,
		chest2.entity_id,
		chest3.entity_id,
		chest4.entity_id,
		], {
			state = ChestStruct.State.Close
		})

	var player := PlayerEntity.new(gs,{})
	# apparently, this gets freed if we don't keep reference, and the signals won't fire
	var systems := [OpenIfLinkedActivatedSytem.new(gs, OpenableComponent.get_c(gs, chest_door.entity_id), [
		ActivateableComponent.get_c(gs, chest1.entity_id),
		ActivateableComponent.get_c(gs, chest2.entity_id),
		ActivateableComponent.get_c(gs, chest3.entity_id),
		ActivateableComponent.get_c(gs, chest4.entity_id),
		])]


	# act on unrelated first
	player.interact(gs, chest5_not_connected.entity_id)
	# assert
	assert_bool(OpenableComponent.get_c(gs, chest_door.entity_id).is_open()).is_equal(false)

	# act on 2 first
	player.interact(gs, chest1.entity_id)
	player.interact(gs, chest2.entity_id)
	# assert (not yet)
	assert_bool(OpenableComponent.get_c(gs, chest_door.entity_id).is_open()).is_equal(false)

	# act on all connected
	player.interact(gs, chest3.entity_id)
	player.interact(gs, chest4.entity_id)
	# assert (open!)
	assert_bool(OpenableComponent.get_c(gs, chest_door.entity_id).is_open()).is_equal(true)

	# close the chest
	player.interact(gs, chest3.entity_id)
	# assert (closed!)
	assert_bool(OpenableComponent.get_c(gs, chest_door.entity_id).is_open()).is_equal(false)
