extends GdUnitTestSuite

func test_inventory() -> void:
	# arrange
	var gs := GameStateContext.new()
	var item := ItemEntity.new(gs, {})
	var item2 := ItemEntity.new(gs, {})
	var item3 := ItemEntity.new(gs, {})
	var player := PlayerEntity.new(gs, {})
	var player2 := PlayerEntity.new(gs, {})

	var inventory_system := InventorySystem.new(gs, [
		InventoryComponent.get_c(gs, player.entity_id),
		InventoryComponent.get_c(gs, player2.entity_id),
			])

	var _systems := [AutopickNearbySystem.new(gs), inventory_system]
	# act
	gs.tag_entity(&"pickable_in_range", player.entity_id, item.entity_id)
	gs.tag_entity(&"pickable_in_range", player.entity_id, item2.entity_id)

	# assert
	var inventory_contents_p2 := InventoryComponent.get_c(gs, player2.entity_id).get_contents()
	assert_array(inventory_contents_p2).is_equal([])

	var inventory_contents_p1 := InventoryComponent.get_c(gs, player.entity_id).get_contents()
	assert_array(inventory_contents_p1).is_equal([
		item.entity_id,
		item2.entity_id,
		])

	gs.tag_entity(&"pickable_in_range", player.entity_id, item3.entity_id)
	inventory_contents_p1 = InventoryComponent.get_c(gs, player.entity_id).get_contents()
	assert_array(inventory_contents_p1).is_equal([
		item.entity_id,
		item2.entity_id,
		item3.entity_id,
		])
	# @todo should not be able to pick something up multiple times? or handle this somewhere? as its a state that should not be feasible if we clean the item after pick properly?
