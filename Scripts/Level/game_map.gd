class_name GameMap

extends Node3D

@export var enviro: Array[Node3D]
@export var lights: Array[Node3D]
@export var overrideEnvironment:Environment

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Manager.gameManager.currentMap = self
	Manager.gameManager.FightEnd.connect(HideMap)
	
func _process(delta: float) -> void:
	pass
	if(Input.is_action_just_pressed("DebugKey")):
		SetEnviroVisibility(false)
		
	if(Input.is_action_just_released("DebugKey")):
		SetEnviroVisibility(true)
		
func HideMap():
	SetEnviroVisibility(false)
	
func SetEnviroVisibility(isVisible:bool):
	for nodeInGroup in get_tree().get_nodes_in_group("Enviro"):
		nodeInGroup.propagate_call("set_visible", [isVisible])
		
	for node in enviro:
		node.propagate_call("set_visible", [isVisible])
		
func SetLightsVisibility(isVisible:bool):
	for node in lights:
		node.propagate_call("set_visible", [isVisible])
