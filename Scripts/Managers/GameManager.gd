class_name GameManager

extends Node

@onready var vibrationManager: VibrationManager = $VibrationManager
@onready var timeManager: TimeManager = $TimeManager
@onready var game_timer: Timer = $GameTimer
@onready var platform_manager: Node = $PlatformManager
@onready var death_background: DeathBackground = $DeathBackground
@onready var redstone_manager: RedstoneManager = $RedstoneManager

var spawn_manager: SpawnManager
var currentMap: GameMap
var currentStage: StageManager

@export var fightStartDelay = 3.0
@export var fightDuration: float = 90.00
@export var timeBeforeRestart = 6.0
var playerSpawns: Array[PlayerSpawn] = []
var players: Array[PlayerCharacter] = []
var eva: Eva

signal FightEnd
signal OnFightStart
signal GameManagerReady

func _ready() -> void:
	#Register
	Manager.gameManager = self
	Manager.timeManager = timeManager
	spawn_manager = Manager.spawnManager
	emit_signal("GameManagerReady")
	
func LaunchFight():
	#await get_tree().create_timer(fightStartDelay,true,false,true).timeout
	game_timer.start(fightDuration)
	OnFightStart.emit()
	for player in players:
		player.ChangeState(player.States.Fall)
		
func RegisterPlayerSpawn(_spawnToAdd:PlayerSpawn):
	if(_spawnToAdd == null): return
	
	if (!players.has(_spawnToAdd)): 
		playerSpawns.append(_spawnToAdd)
	
func RegisterPlayer(_playerToAdd:PlayerCharacter):
	if(_playerToAdd == null): return
	
	if (!players.has(_playerToAdd)): 
		players.append(_playerToAdd)
		_playerToAdd.OnPlayerDeath.connect(OnAnyPlayerDeath)
		_playerToAdd.connect("OnPlayerTakeDamage", Callable(spawn_manager, "OnAnyPlayerTakeDamage"))
		PlacePlayerOnSpawnPoint(_playerToAdd)
		#Set new camera target
		Manager.gameCamera.AddCameraTarget(_playerToAdd)

func PlacePlayerOnSpawnPoint(player:PlayerCharacter):
	if(playerSpawns.size() <= 0):return
	
	for spawn in playerSpawns:
		if(spawn.playerID == player.playerID):
			player.global_position = spawn.global_position
			return
	
func RegisterEva(_evaToAdd:Eva):
	if(_evaToAdd == null): return
	eva = _evaToAdd


func OnAnyPlayerDeath():
	Manager.ChangeGameState(GameStates.GameState.FightOutro)
	FightEnd.emit()
	
func GetWinner() -> PlayerCharacter:
	#check who is alive
	for player in players:
		if(!player.isDead): 
			return player
	
	return null
	
func GetPlayerOpponent(_player:PlayerCharacter) -> PlayerCharacter:
	for player in players:
		if(player != _player): 
			return player
	return null
	
func GetRandomPlayer() -> PlayerCharacter:
	randomize()
	var ranIndex = randi_range(0,players.size()-1)
	return players[ranIndex]
	
	
func GetPlayerFromIndex(index:int) -> PlayerCharacter:
	for player in players:
		if(player.playerID == index):
			return player
	return null
