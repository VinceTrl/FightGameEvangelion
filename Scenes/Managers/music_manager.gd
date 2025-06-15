extends Node

@onready var stage_music: AudioStreamPlayer = $StageMusic


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("i'm the MUSIC manager")
	Manager.gameStateManager.OnTitleScreenStart.connect(StartStageMusic)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func StartStageMusic():
	print("START MUSIC")
	stage_music.play()
