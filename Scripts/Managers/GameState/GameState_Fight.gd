extends GameStates

func _ready():
	state = GameState.Fight
	manager = Manager

func EnterState():
	manager.gameManager.LaunchFight()
	manager.spawnManager.TimerRandomSpawn()
	
func ExitState():
	pass

func Draw():
	pass
	
func Update(delta: float):
	pass
