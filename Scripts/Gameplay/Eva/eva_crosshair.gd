extends Node3D

@export var offset:Vector3 = Vector3.ZERO
@export_range(0,1,0.05) var weight:float = 0.25
@export var target:Node3D
var follow:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(target):
		StartFollowTarget(target)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	FollowTarget()
	
func StartFollowTarget(newTarget:Node3D):
	if(newTarget):
		target = newTarget
		follow = true
	
func StopFollowTarget():
	follow = false
	target = null

func FollowTarget():
	if(!follow):return
	if(!target):return
	
	global_position = lerp(global_position,target.global_position + offset,weight)
