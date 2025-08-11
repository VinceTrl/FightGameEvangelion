class_name Vfx2D

extends AnimatedSprite3D

@export var instanceScale: Vector3 = Vector3.ONE
@export var instanceOffset: Vector3
@export var instanceRotation:Vector3 = Vector3.ZERO
@export var ignoreTimeScale: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scale = instanceScale
	global_position = global_position + instanceOffset
	global_rotation.z = deg_to_rad(instanceRotation.z)
	animation_finished.connect(DestroyNode)

func _process(delta: float) -> void:
	ScaleAnimSpeed()

func DestroyNode():
	queue_free()
	
func ScaleAnimSpeed():
	if(ignoreTimeScale):
		var timeScale = Engine.time_scale
		timeScale = clampf(timeScale,0.0,1.0)
		var animScale = lerp(4.0,1.0,timeScale)
		speed_scale = animScale
		print("VFX 2D SPEED SCALE = " + str(speed_scale))
