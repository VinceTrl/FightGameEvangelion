extends GameStates

var canHandleInput = true

func _ready():
	state = GameState.TitleScreen
	manager = Manager

func EnterState():
	print("enter title state")
	canHandleInput = true
	
func ExitState():
	pass

func Draw():
	pass
	
func Update(delta: float):
	if(Input.is_action_pressed("MenuAccept_Global") and canHandleInput):
		print("INPUT")
		canHandleInput = false
		manager.LoadGameScene()
		manager.titleScreen.titleScreenExit.connect(ExitTitleScreen)
		manager.titleScreen.AcceptTitleScreen()

func ExitTitleScreen():
	manager.titleScreen.titleScreenExit.disconnect(ExitTitleScreen)
	manager.ChangeGameState(GameState.FightIntro)
