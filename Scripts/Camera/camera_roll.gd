extends Node3D

@export var tweenTime:float = 1
@export var easeType:Tween.EaseType = Tween.EASE_IN_OUT
@export var transType:Tween.TransitionType = Tween.TRANS_EXPO

var isRolling:bool = false
	
func RollCamera():
	if(isRolling):return
	isRolling = true
	TweenRoll(180)
	
func ResetRoll():
	if(!isRolling):return
	TweenRoll(0.0)
	isRolling = false
	pass
	
func TweenRoll(targetRoll:float = 180):
	var tween = get_tree().create_tween()
	tween.set_ease(easeType)
	tween.set_trans(transType)
	tween.set_parallel(true)
	tween.tween_property(self,"rotation_degrees:z",targetRoll,tweenTime)
	await tween.finished
