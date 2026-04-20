class_name AutopickNearbySystem
extends RefCounted

# @todo we don't need execute right because this is a "trigger" on certain conditions, like it runs based on signals

var looters : Array[LooterComponent]
var pickables : Array[PickableComponent]
var gs : GameStateContext

signal picked(by_entity_id: int, entity_id: int)

func _init(p_gs: GameStateContext, p_looters: Array[LooterComponent]) -> void:
	gs = p_gs
	looters = p_looters

	p_gs.tag_changed.connect(on_tag_changed)

func on_tag_changed(p_tag_name: StringName, p_source_entity_id: int, p_entity_id: int) -> void:
	if p_tag_name != &"pickable_in_range":
		return
	var lc := LooterComponent.get_c(gs, p_source_entity_id)
	if ArrayUtils.in_array_is_same(looters, lc):
		lc.add_loot(p_entity_id)
		picked.emit(p_source_entity_id, p_entity_id)
		print("loot ", p_entity_id, "for", p_source_entity_id)
	
