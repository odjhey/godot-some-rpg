extends GdUnitTestSuite

# levers should open connected doors
func test_is_activated() -> void:
	# arrange
	var gs := GameStateContext.new()
	var door := DoorEntity.new(gs, {
		state = ChestStruct.State.Close
		})
	var lever := LeverEntity.new(gs, ActivateableComponent.State.Deactivated)
	var player := PlayerEntity.new(gs, {})

	# apparently, this gets freed if we don't keep reference, and the signals won't fire
	var systems := [OpenIfLinkedActivatedSytem.new(gs, OpenableComponent.get_c(gs, door.entity_id), [
		ActivateableComponent.get_c(gs, lever.entity_id)
		])]
	
	assert_int(systems.size()).is_equal(1)

	# act
	player.interact(gs, lever.entity_id)

	# assert
	assert_bool(OpenableComponent.get_c(gs, door.entity_id).is_open()).is_equal(true)
	assert_bool(ActivateableComponent.get_c(gs, lever.entity_id).is_activated()).is_equal(true)

	# act
	player.interact(gs, lever.entity_id)

	# assert
	assert_bool(OpenableComponent.get_c(gs, door.entity_id).is_open()).is_equal(false)
	assert_bool(ActivateableComponent.get_c(gs, lever.entity_id).is_activated()).is_equal(false)
