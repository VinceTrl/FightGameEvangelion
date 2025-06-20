extends GameStates

const WINNER_SCREEN = preload("res://Scenes/GUI/winner_screen.tscn")
var canHandleInput = false
var screenInstance

func _ready():
	state = GameState.WinnerScreen
	manager = Manager

func EnterState():
	print("enter Win Screen state")
	screenInstance = WINNER_SCREEN.instantiate()
	add_child(screenInstance)
	Manager.gameStateManager.OnWinnerScreenStart.emit()
	await get_tree().create_timer(8.0,true,false,true).timeout
	RestartGame()
	
func ExitState():
	#screenInstance as Node
	Manager.gameStateManager.OnWinnerScreenEnd.emit()
	screenInstance.queue_free()

func Draw():
	pass
	
func Update(delta: float):
	pass
	#if(Input.is_action_pressed("MenuAccept_Global") and canHandleInput):
		#canHandleInput = false
		#RestartGame()
		
func RestartGame():
	var timer = get_tree().create_timer(0.5,true,false,true)
	await timer.timeout
	manager.LoadTitleScene()
	#get_tree().reload_current_scene()
	#manager.ChangeGameState(GameState.FightIntro)
