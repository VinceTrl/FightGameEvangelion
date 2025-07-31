extends Node3D

@export var bumpers: Array[Bumper]
@export var hurtBoxes: Array[Hurtbox]
@export var animationTime = 0.25
@export var animationCurve:Curve
@export var maxScale: Vector3 = Vector3.ONE

var tween
var iniScale

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#if(!bumperOwner): push_error("NO OWNER REFERENCED FOR BUMPER ANIMATION" + str(name))
	iniScale = scale
	
	for bumper in bumpers:
		bumper.OnBumperStart.connect(BumpAnimation)
		
	for hurtbox in hurtBoxes:
		hurtbox.OnHurtboxHit.connect(BumpAnimation)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func BumpAnimation():
	print("launch bump animation")
	
	if(tween):
		tween.kill()
		scale = iniScale
	
	tween = get_tree().create_tween()
	tween.set_parallel(true)
	
	tween.tween_property(self,"scale:x",maxScale.x,animationTime).as_relative().set_custom_interpolator(tweenCurve)
	tween.tween_property(self,"scale:y",maxScale.y,animationTime).as_relative().set_custom_interpolator(tweenCurve)
	tween.tween_property(self,"scale:z",maxScale.z,animationTime).as_relative().set_custom_interpolator(tweenCurve)
	
	await tween.finished
	scale = iniScale
	
func tweenCurve(v):
	return Global.GetCustomTweenCurveValue(animationCurve,v)
