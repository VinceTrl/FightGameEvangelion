extends Node

var effect:AudioEffectRecord
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
@export var replayDuration:float = 3.0

var replayTimeCode:float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var idx = AudioServer.get_bus_index("SFX")
	effect = AudioServer.get_bus_effect(idx, 0)
	call_deferred("ConnectSignals")
	pass # Replace with function body.
	
	
func ConnectSignals():
	Manager.OnFightStart.connect(StartRecording)
	Manager.OnFightFinish.connect(StopRecording)
	Manager.replayManager.ReplayStart.connect(StartAudioReplay)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(effect.is_recording_active()):
		print("AUDIO REPLAY : current length : " + str(effect.get_recording().get_length()))
	if(Input.is_action_just_pressed("TakeScreenshot")):
		DebugAudioRecord()
	pass
	
	
func DebugAudioRecord():
	SaveRecording()
	PlayRecordAudio()
	await get_tree().create_timer(replayDuration).timeout
	audio_stream_player_3d.stop()
	StartRecording()
	pass
	
func StartRecording():
	effect.set_recording_active(true)
	print("AUDIO REPLAY : Start Recording")
	
func StopRecording():
	
	var gameTime:= Manager.gameManager.fightDuration
	var timeLeft := Manager.gameManager.game_timer.time_left
	var timecode := (gameTime - timeLeft) - replayDuration
	timecode = clampf(timecode,0.0,gameTime)
	replayTimeCode = timecode
	await get_tree().create_timer(1.0).timeout
	SaveRecording()
	print("AUDIO REPLAY : Stop Recording")

func SaveRecording():
	effect.set_recording_active(false)
	
	
func StartAudioReplay():
	print("AUDIO REPLAY : PLAY AUDIO TIME AT " + str(replayTimeCode))
	PlayRecordAudio(replayTimeCode)
	pass
	
	
func PlayRecordAudio(from_time:float = 0.0):
	audio_stream_player_3d.stream = effect.get_recording()
	print("AUDIO REPLAY : duration : " + str(effect.get_recording().get_length()))
	audio_stream_player_3d.play(from_time)
	print("Play AUDIO")
	pass
