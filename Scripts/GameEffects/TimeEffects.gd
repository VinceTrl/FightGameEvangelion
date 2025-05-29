class_name TimeManager

extends Node

signal freezeFrameFinished
signal slowMotionFinished

func _ready() -> void:
	Manager.timeManager = self
	

func freezeFrame(timescale: float = 0.001 ,duration: float = 0.1) -> void:
	print("FREEZE FRAME")
	Engine.time_scale = timescale
	await get_tree().create_timer(duration,true,false,true).timeout
	Engine.time_scale = 1.0
	emit_signal("freezeFrameFinished")
	
func slowMotion(timescale: float = 0.25 ,duration: float = 1) -> void:
	print("SLOW MO")
	Engine.time_scale = timescale
	await get_tree().create_timer(duration,true,false,true).timeout
	Engine.time_scale = 1.0
	emit_signal("slowMotionFinished")
