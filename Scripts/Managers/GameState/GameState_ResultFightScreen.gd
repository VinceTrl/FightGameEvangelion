extends GameStates

var canHandleInput = true

func _ready():
	state = GameState.FightResult
	manager = Manager

func EnterState():
	print("enter Result state")
	canHandleInput = true
	Manager.gameStateManager.OnResultScreenStart.emit()
	Manager.masterUI.result_screen.StartResult()
	await get_tree().create_timer(3.0,true,false,true).timeout
	ExitGame()
	
func ExitState():
	Manager.gameStateManager.OnResultScreenEnd.emit()

func Draw():
	pass
	
func Update(delta: float):
	pass
	#if(Input.is_action_pressed("MenuAccept_Global") and canHandleInput):
		#print("INPUT")
		#canHandleInput = false
		#ExitGame()
		
func ExitGame():
	var timer = get_tree().create_timer(0.5,true,false,true)
	await timer.timeout
	
	Manager.postProcessEffects.ResetAll()
	
	if(manager.scoreManager.fightIsFinished):
		#go to winner screen
		manager.ChangeGameState(GameState.WinnerScreen)
	else:
		manager.ReloadGameScene() #go to fight
	#get_tree().reload_current_scene()
	#manager.ChangeGameState(GameState.FightIntro)
