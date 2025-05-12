class_name GameManager

extends Node

@onready var vibrationManager: VibrationManager = $VibrationManager
@onready var timeManager: TimeManager = $TimeManager
@onready var game_timer: Timer = $GameTimer
@export var fightDuration: float = 90.00
@export var timeBeforeRestart = 6.0

var players: Array[PlayerCharacter] = []

func _ready() -> void:
	
	#Register
	Manager.gameManager = self
	Manager.timeManager = timeManager
	game_timer.start(fightDuration)
	
	
func RegisterPlayer(_playerToAdd:PlayerCharacter):
	if(_playerToAdd == null): return
	
	if (!players.has(_playerToAdd)): 
		players.append(_playerToAdd)
		_playerToAdd.OnPlayerDeath.connect(OnAnyPlayerDeath)
		
		
func OnAnyPlayerDeath():
	
	var timer = get_tree().create_timer(timeBeforeRestart,true,false,true)
	await timer.timeout
	
	get_tree().reload_current_scene()
