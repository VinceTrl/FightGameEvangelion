extends Node3D

@export var axisLock:Vector3i = Vector3i.BACK
@export var xLock:bool
@export var yLock:bool
@export var zLock:bool
var baseRotation:Vector3


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	baseRotation = global_rotation
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Locking()
	
func Locking():
	var xRot:float = global_rotation.x
	var yRot:float = global_rotation.y
	var zRot:float = global_rotation.z
	
	if(xLock): xRot = baseRotation.x
	if(yLock): yLock = baseRotation.y
	if(zLock): zLock = baseRotation.z
	
	var rot := Vector3(xRot,yRot,zRot)
	global_rotation = rot
