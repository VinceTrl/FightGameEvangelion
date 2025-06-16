class_name GameManager

extends Node

@onready var vibrationManager: VibrationManager = $VibrationManager
@onready var timeManager: TimeManager = $TimeManager
@onready var game_timer: Timer = $GameTimer
@onready var shitpost_gui: ShitpostGUI = $ShitpostGUI
@onready var platform_manager: Node = $PlatformManager

@export var fightStartDelay = 3.0
@export var fightDuration: float = 90.00
@export var timeBeforeRestart = 6.0

var players: Array[PlayerCharacter] = []

signal FightEnd
signal GameManagerReady

func _ready() -> void:
	#Register
	Manager.gameManager = self
	Manager.timeManager = timeManager
	emit_signal("GameManagerReady")
	
func LaunchFight():
	#await get_tree().create_timer(fightStartDelay,true,false,true).timeout
	game_timer.start(fightDuration)
	
	for player in players:
		player.ChangeState(player.States.Fall)
	
func RegisterPlayer(_playerToAdd:PlayerCharacter):
	if(_playerToAdd == null): return
	
	if (!players.has(_playerToAdd)): 
		players.append(_playerToAdd)
		_playerToAdd.OnPlayerDeath.connect(OnAnyPlayerDeath)


func OnAnyPlayerDeath():
	Manager.ChangeGameState(GameStates.GameState.FightOutro)
	FightEnd.emit()
	
func GetWinner() -> PlayerCharacter:
	#check who is alive
	for player in players:
		if(!player.isDead): 
			return player
	
	return null
