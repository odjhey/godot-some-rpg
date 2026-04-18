extends GdUnitTestSuite

func test_change_control_target() -> void:
	var gs := GameStateContext.new()
	var player_a := PlayerEntity.new(gs, {})
	var player_b := PlayerEntity.new(gs, {})
	var player_c := PlayerEntity.new(gs, {})

	var controller_manager := ControlCycleManager.new(gs, [player_a.entity_id, player_b.entity_id, player_c.entity_id] , {
		default_target = player_a.entity_id
		})


	assert_that(controller_manager.get_active_target()).is_equal(player_a.entity_id)
	controller_manager.next()
	assert_that(controller_manager.get_active_target()).is_equal(player_b.entity_id)
	controller_manager.prev()
	assert_that(controller_manager.get_active_target()).is_equal(player_a.entity_id)
	controller_manager.set_target(player_c.entity_id)
	assert_that(controller_manager.get_active_target()).is_equal(player_c.entity_id)

