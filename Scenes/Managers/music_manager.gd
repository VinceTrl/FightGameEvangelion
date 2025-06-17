extends Node

@onready var stage_music: AudioStreamPlayer = $StageMusic
@onready var voicelines: AudioStreamPlayer = $Voicelines
@onready var victory_sound: AudioStreamPlayer = $VictorySound


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("i'm the MUSIC manager")
	Manager.gameStateManager.OnTitleScreenStart.connect(StartStageMusic)
	Manager.gameStateManager.OnResultScreenStart.connect(LaunchVoiceline)
	Manager.gameStateManager.OnWinnerScreenStart.connect(LaunchVictorySound)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func StartStageMusic():
	print("START MUSIC")
	stage_music.play()
	victory_sound.stop()

func LaunchVoiceline():
	print("START VOICELINE")
	voicelines.play()
	
func LaunchVictorySound():
	print("START VICTORY")
	stage_music.stop()
	victory_sound.play()
