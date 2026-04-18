extends GdUnitTestSuite


func test_choose_loot() -> void:
	var gs := GameStateContext.new()
	var loot1 := LootItemEntity.new(gs, {label = "sword"})
	var loot2 := LootItemEntity.new(gs, {label = "shield"})
	var loot3 := LootItemEntity.new(gs, {label = "gun"})
	var choose_one_loot_group := SingleChoiceLootGroupEntity.new(gs, [
		loot1.entity_id,
		loot2.entity_id,
		loot3.entity_id,
		], {})


	var player := PlayerEntity.new(gs, {})

	assert_that(choose_one_loot_group.can_choose()).is_equal(true)

	player.interact(gs, loot2.entity_id)
	assert_that(choose_one_loot_group.chosen_id()).is_equal(loot2.entity_id)

	player.interact(gs, loot3.entity_id)
	assert_that(choose_one_loot_group.can_choose()).is_equal(false)
	# should not change
	assert_that(choose_one_loot_group.chosen_id()).is_equal(loot2.entity_id)

	# @todo inventory or something should update

	
