extends GameStates

func _ready():
	state = GameState.Replay
	manager = Manager

func EnterState():
	manager.replayManager.StartReplay()
	await manager.replayManager.ReplayFinished
	manager.ChangeGameState(GameState.FightResult)
	
func ExitState():
	pass

func Draw():
	pass
	
func Update(delta: float):
	pass
