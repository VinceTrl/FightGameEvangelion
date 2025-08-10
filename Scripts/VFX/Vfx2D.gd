class_name Vfx2D

extends AnimatedSprite3D

@export var instanceScale: Vector3 = Vector3.ONE
@export var instanceOffset: Vector3
@export var instanceRotation:Vector3 = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scale = instanceScale
	global_position = global_position + instanceOffset
	global_rotation.z = deg_to_rad(instanceRotation.z)
	animation_finished.connect(DestroyNode)


func DestroyNode():
	queue_free()
