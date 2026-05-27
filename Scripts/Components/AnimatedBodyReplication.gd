extends AnimatableBody3D

@export var nodeToCopy:Node3D
@export var offset:Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = nodeToCopy.global_position + offset
	#rotation_degrees = nodeToCopy.rotation_degrees
	#global_rotation = nodeToCopy.global_rotation
	pass
