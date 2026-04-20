class_name InventorySystem
extends RefCounted

var gs : GameStateContext
var inventories: Array[InventoryComponent] = []

func _init(p_gs: GameStateContext, p_inventories: Array[InventoryComponent]) -> void:
	gs = p_gs
	inventories = p_inventories

