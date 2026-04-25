extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var time:float = 0.5
@export var moveEaseType:Tween.EaseType = Tween.EASE_OUT
@export var moveTransType:Tween.TransitionType = Tween.TRANS_QUART

var startPosition:Vector3
var endPosition:Vector3

signal TrailStart
signal TrailFinished

func StartTrail(start:Vector3,end:Vector3):
	global_position = start
	animation_player.play("ActiveTrail")
	TrailStart.emit()
	var tween = get_tree().create_tween()
	tween.set_ease(moveEaseType)
	tween.set_trans(moveTransType)
	tween.set_parallel(true)
	tween.tween_property(self,"global_position",end,time)
	
	await tween.finished
	animation_player.play("InactiveTrail")
	TrailFinished.emit()
	global_position = start
	
