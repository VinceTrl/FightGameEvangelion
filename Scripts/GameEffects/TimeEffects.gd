class_name TimeManager

extends Node

@export var canFreezeTime = true
@export var canSlowTime = true

signal freezeFrameFinished
signal slowMotionFinished

func _ready() -> void:
	Manager.timeManager = self
	ResetTime()
	

func freezeFrame(timescale: float = 0.001 ,duration: float = 0.1) -> void:
	if(!canFreezeTime):return
	
	#print("FREEZE FRAME")
	Engine.time_scale = timescale
	await get_tree().create_timer(duration,true,false,true).timeout
	ResetTime()
	emit_signal("freezeFrameFinished")
	
func slowMotion(timescale: float = 0.25 ,duration: float = 1) -> void:
	if(!canSlowTime):return
	
	#print("SLOW MO")
	Engine.time_scale = timescale
	await get_tree().create_timer(duration,true,false,true).timeout
	ResetTime()
	emit_signal("slowMotionFinished")
	
func ResetTime():
	Engine.time_scale = 1.0
