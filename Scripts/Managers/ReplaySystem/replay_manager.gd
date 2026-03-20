class_name ReplayManager

extends Node

@export_group("References")
@export var gameCapture:GameCapture
@export var gameReplay:GameReplay

signal CaptureStart
signal CaptureStop
signal ReplayStart
signal ReplayFinished

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Manager.replayManager = self
	
	#connect signals
	Manager.OnFightStart.connect(StartCapture)
	#Manager.OnFightFinish.connect(LoadReplay)
	Manager.OnFightFinish.connect(StopCapture)
	
	gameReplay.ReplayFinished.connect(OnReplayFinished)


func StartCapture():
	gameCapture.StartCapture()
	CaptureStart.emit()
	
func StopCapture():
	await get_tree().create_timer(1.0).timeout
	gameCapture.StopCapture()
	CaptureStop.emit()
	LoadReplay()
	
func LoadReplay():
	gameReplay.LoadTextures(gameCapture)
	pass
	
func StartReplay():
	ReplayStart.emit()
	gameReplay.StartReplaySequence()
	pass
	
func OnReplayFinished():
	ReplayFinished.emit()
