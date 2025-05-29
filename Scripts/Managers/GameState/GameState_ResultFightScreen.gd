extends GameStates

var canHandleInput = true

func _ready():
	state = GameState.FightResult
	manager = Manager

func EnterState():
	print("enter Result state")
	canHandleInput = true
	Manager.masterUI.result_screen.StartResult()
	
func ExitState():
	pass

func Draw():
	pass
	
func Update(delta: float):
	if(Input.is_action_pressed("MenuAccept_Global") and canHandleInput):
		print("INPUT")
		canHandleInput = false
		ExitGame()
		
func ExitGame():
	var timer = get_tree().create_timer(0.5,true,false,true)
	await timer.timeout
	get_tree().reload_current_scene()
	manager.ChangeGameState(GameState.TitleScreen)
