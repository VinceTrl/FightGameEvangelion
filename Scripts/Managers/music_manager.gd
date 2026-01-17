extends Node

@onready var stage_music: AudioStreamPlayer = $StageMusic
@onready var voicelines: AudioStreamPlayer = $Voicelines
@onready var victory_sound: AudioStreamPlayer = $VictorySound
var muteMusic:bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("i'm the MUSIC manager")
	Manager.gameStateManager.OnTitleScreenStart.connect(StartStageMusic)
	Manager.gameStateManager.OnResultScreenStart.connect(LaunchVoiceline)
	Manager.gameStateManager.OnWinnerScreenStart.connect(LaunchVictorySound)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("Mute")):
		muteMusic = not muteMusic
		MuteMusic()
	
	
func MuteMusic():
	stage_music.stream_paused = muteMusic
	if(!muteMusic and !stage_music.playing):
		stage_music.play()
	
func StartStageMusic():
	print("START MUSIC")
	if(!muteMusic): stage_music.play()
	victory_sound.stop()

func LaunchVoiceline():
	print("START VOICELINE")
	voicelines.play()
	
func LaunchVictorySound():
	print("START VICTORY")
	stage_music.stop()
	victory_sound.play()
