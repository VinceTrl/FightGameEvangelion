extends Node3D

@export var distanceToExplode:float = 0.2
@export var moveSpeed:float = 2.0
@export var moveDirection:Vector3 = Vector3.ZERO
@export var delayToExplode:float = 1.0

var canMove = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func Move(delta:float,moveDir:Vector3 = moveDirection):
	if(!canMove): return
	global_position += moveDirection * (moveSpeed * delta)
	
func CheckGround() -> bool:
	return true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
