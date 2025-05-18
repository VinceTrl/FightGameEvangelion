extends GameStates

func _ready():
	state = GameState.Fight
	manager = Manager

func EnterState():
	manager.gameManager.LaunchFight()
	
func ExitState():
	pass

func Draw():
	pass
	
func Update(delta: float):
	pass
