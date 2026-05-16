class_name RotationToTarget

extends Node3D

@export var nodeToRotate:Node3D
@export var rotateToTarget:bool = false
@export var lookTarget: Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func StartLookAt(target:Node3D):
	if(target):
		lookTarget = target
		rotateToTarget = true
		
		
func StopLookAt():
	rotateToTarget = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	LookAtTarget()
	
	
func LookAtTarget():
	if(!rotateToTarget): return
	if(lookTarget == null): return

	nodeToRotate.look_at(lookTarget.global_position,Vector3.UP,false)
