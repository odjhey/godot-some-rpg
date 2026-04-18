extends GdUnitTestSuite

class SignalSpy:
	var from_id: int
	var to_id: int
	func _init(portal: PortalEntity) -> void:
		portal.teleport_requested.connect(on_teleport_requested)
	func on_teleport_requested(p_from: int, p_to: int) -> void:
		from_id = p_from
		to_id = p_to

func test_a_b_teleport() -> void:
	var gs := GameStateContext.new()
	var portal_a := PortalEntity.new(gs, 0, {})
	var portal_b := PortalEntity.new(gs, portal_a.entity_id, {})
	portal_a.set_portal_pair(portal_b.entity_id)
	var player := PlayerEntity.new(gs, {})

	var listener := SignalSpy.new(portal_a)

	player.interact(gs, portal_a.entity_id)
	assert_that(listener.from_id).is_equal(player.entity_id)
	assert_that(listener.to_id).is_equal(portal_b.entity_id)

	listener = SignalSpy.new(portal_b)
	player.interact(gs, portal_b.entity_id)
	assert_that(listener.from_id).is_equal(player.entity_id)
	assert_that(listener.to_id).is_equal(portal_a.entity_id)
