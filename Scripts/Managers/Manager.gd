extends Node

const GAME_STATE_MANAGER = preload("res://Scenes/Managers/game_state_manager.tscn")

var gameManager : GameManager
var timeManager: TimeManager
var gameCamera: GameCamera
var gameStateManager: GameStateManager
var masterUI: MasterUI
var postProcessEffects: PostProcessEffects
var spawnManager: SpawnManager

var previousGameState : GameStates.GameState = GameStates.GameState.TitleScreen
var currentGameState : GameStates.GameState = GameStates.GameState.TitleScreen

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("i'm the manager")
	var stateManager = GAME_STATE_MANAGER.instantiate()
	add_child(stateManager)
	gameStateManager = stateManager
	ChangeGameState(currentGameState)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func ChangeGameState(_nextState: GameStates.GameState):
	previousGameState = currentGameState
	currentGameState = _nextState
	gameStateManager.previousState = GetGameState(previousGameState)
	gameStateManager.currentState = GetGameState(currentGameState)
	gameStateManager.previousState.ExitState()
	gameStateManager.currentState.EnterState()
	
	
func GetGameState(_state: GameStates.GameState) -> GameStates:
	for childState in gameStateManager.get_children():
		if(childState is GameStates):
			childState as GameStates
			if(childState.state == _state): return childState
	
	return null
