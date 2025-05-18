extends GameStates

func _ready():
	state = GameState.FightIntro
	manager = Manager

func EnterState():
	manager.masterUI.fight_text.StartFightText()
	await manager.masterUI.fight_text.FightTextOut
	manager.ChangeGameState(GameState.Fight)
	
func ExitState():
	pass

func Draw():
	pass
	
func Update(delta: float):
	pass
