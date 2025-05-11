extends Resource
class_name ShakeParameters

@export var shakeName: StringName = "CameraShake"
@export var shakeTime: float = 2.0
@export var minMagnitude: float = 0.005
@export var maxMagnitude: float = 0.05
@export var magnitudeOverTime: Curve
