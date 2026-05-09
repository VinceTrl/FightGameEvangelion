extends Node3D

@export var health:HealthComponent
@export var maxScale:Vector3 = Vector3.ONE
@export var minScale:Vector3 = Vector3.ZERO
@export var scaleWhenDead:bool = true
@export var scaleCurve:Curve

#@export_category("animation")
@export var scaleTime:float = 1
@export var easeType:Tween.EaseType = Tween.EASE_IN_OUT
@export var transType:Tween.TransitionType = Tween.TRANS_LINEAR

var currentTween:Tween
var targetScale:Vector3
var maxHealth:int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	maxHealth = health.healthPoints
	health.IncreaseHealth.connect(SetTargetScale)
	health.ReduceHealth.connect(SetTargetScale)
	SetTargetScale()
	pass # Replace with function body.

func SetTargetScale():
	var ratio:float = float(health.healthPoints) / float(maxHealth)
	var weight = scaleCurve.sample(ratio)
	targetScale = lerp(minScale,maxScale,weight)
	if(health.isDead and !scaleWhenDead): return
	TweenScale()
	
func TweenScale():
	var tween = get_tree().create_tween()
	currentTween = tween
	tween.set_ease(easeType)
	tween.set_trans(transType)
	tween.set_parallel(true)
	tween.tween_property(self,"scale",targetScale,scaleTime)
	await tween.finished
