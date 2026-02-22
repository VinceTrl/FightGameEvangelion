extends Node

@export var parent:Node3D
@export var killLimit:float = -20
@export var checkOutOfBound:bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(!parent): parent = owner
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	ProcessCheckOutOfBound()

func ProcessCheckOutOfBound():
	if(!checkOutOfBound):return
	if(parent.global_position.y < killLimit):
		checkOutOfBound = false
		parent.queue_free()
