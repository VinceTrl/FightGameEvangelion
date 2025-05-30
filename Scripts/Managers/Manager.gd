extends Node

const GAME_STATE_MANAGER = preload("res://Scenes/Managers/game_state_manager.tscn")
const SCORE_MANAGER = preload("res://Scenes/Managers/score_manager.tscn")
const GAME_SCENE = preload("res://Scenes/game.tscn")

var gameManager : GameManager
var timeManager: TimeManager
var gameCamera: GameCamera
var gameStateManager: GameStateManager
var masterUI: MasterUI
var postProcessEffects: PostProcessEffects
var spawnManager: SpawnManager
var scoreManager: ScoreManager
var titleScreen: TitleScreen

var previousGameState : GameStates.GameState = GameStates.GameState.TitleScreen
var currentGameState : GameStates.GameState = GameStates.GameState.TitleScreen

signal OnGameManagerReady()
signal OnFightFinish
signal OnGameStateChanged(_newState: GameStates.GameState)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("i'm the manager")
	
	var stateManager = GAME_STATE_MANAGER.instantiate()
	add_child(stateManager)
	gameStateManager = stateManager
	ChangeGameState(currentGameState)
	
	var _scoreManager = SCORE_MANAGER.instantiate()
	add_child(_scoreManager)
	scoreManager = _scoreManager


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print("current state : " + str(currentGameState))
	pass

func ChangeGameState(_nextState: GameStates.GameState):
	previousGameState = currentGameState
	currentGameState = _nextState
	gameStateManager.previousState = GetGameState(previousGameState)
	gameStateManager.currentState = GetGameState(currentGameState)
	gameStateManager.previousState.ExitState()
	gameStateManager.currentState.EnterState()
	
	emit_signal("OnGameStateChanged",_nextState)
	
func GetGameState(_state: GameStates.GameState) -> GameStates:
	for childState in gameStateManager.get_children():
		if(childState is GameStates):
			childState as GameStates
			if(childState.state == _state): return childState
	
	return null
	
func LoadGameScene():
	var game_scene_instance = GAME_SCENE.instantiate()
	get_tree().root.add_child(game_scene_instance)
	get_tree().set_current_scene(game_scene_instance)
	
func ReloadGameScene():
	get_tree().current_scene.queue_free()
	await get_tree().process_frame # attendre la suppression effective

	# Instancier la nouvelle
	var game_scene_instance = GAME_SCENE.instantiate()
	get_tree().root.add_child(game_scene_instance)
	get_tree().set_current_scene(game_scene_instance)
	
	if game_scene_instance.has_signal("OnSceneReady"):
		game_scene_instance.connect("OnSceneReady",OnGameSceneReloaded)
	else:
		push_error("La scène n'a pas le signal `scene_ready`")
	
	#print("READY")
	#await get_tree().create_timer(1.0,true,false,true)
	#ChangeGameState(GameStates.GameState.FightIntro)
	
func OnGameSceneReloaded():
	ChangeGameState(GameStates.GameState.FightIntro)
