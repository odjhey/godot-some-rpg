extends GdUnitTestSuite


func test_choose_loot():
	var gs = GameStateContext.new()
	var loot1 = LootItemEntity.new(gs, {label = "sword"})
	var loot2 = LootItemEntity.new(gs, {label = "shield"})
	var loot3 = LootItemEntity.new(gs, {label = "gun"})
	var choose_one_loot_group = SingleChoiceLootGroupEntity.new(gs, [
		loot1.entity_id,
		loot2.entity_id,
		loot3.entity_id,
		], {})

	# @todo see how we can do this as init
	LootItemEntity.set_group(gs, loot1.entity_id, choose_one_loot_group.entity_id)
	LootItemEntity.set_group(gs, loot2.entity_id, choose_one_loot_group.entity_id)
	LootItemEntity.set_group(gs, loot3.entity_id, choose_one_loot_group.entity_id)

	var player = PlayerEntity.new(gs, {})

	assert_that(choose_one_loot_group.can_choose()).is_equal(true)

	player.interact(gs, loot2.entity_id)
	assert_that(choose_one_loot_group.chosen_id()).is_equal(loot2.entity_id)

	player.interact(gs, loot3.entity_id)
	assert_that(choose_one_loot_group.can_choose()).is_equal(false)
	# should not change
	assert_that(choose_one_loot_group.chosen_id()).is_equal(loot2.entity_id)

	# @todo inventory or something should update

	
