class_name AutopickNearbySystem
extends RefCounted

var gs : GameStateContext

signal picked(by_entity_id: int, entity_id: int)

func _init(p_gs: GameStateContext) -> void:
	gs = p_gs
	p_gs.tag_changed.connect(on_tag_changed)

func on_tag_changed(p_tag_name: StringName, p_source_entity_id: int, p_entity_id: int) -> void:
	if p_tag_name != &"pickable_in_range":
		return
	var lc := LooterComponent.get_c(gs, p_source_entity_id)
	var inventory := InventoryComponent.get_c(gs, p_source_entity_id)
	if lc != null:
		if inventory != null:
			inventory.add_item(p_entity_id)
		picked.emit(p_source_entity_id, p_entity_id)
		print("loot ", p_entity_id, "for", p_source_entity_id)
	
