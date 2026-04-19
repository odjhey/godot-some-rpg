class_name OpenIfLinkedActivatedSytem
extends RefCounted

var openable : OpenableComponent
var linked_activateables : Array[ActivateableComponent]
var gs : GameStateContext

func _init(p_gs: GameStateContext, p_openable: OpenableComponent, p_linked_activateables: Array[ActivateableComponent]) -> void:
	gs = p_gs
	openable = p_openable
	linked_activateables = p_linked_activateables

	for a_c in p_linked_activateables:
		a_c.changed.connect(execute)

func execute() -> void:
	var all_is_activated := true
	for a_c in linked_activateables:
		if not a_c.is_activated():
			all_is_activated = false
			break
	if all_is_activated:
		openable.open()
	else:
		openable.close()
	
