extends GameStates

func _ready():
	state = GameState.FightOutro
	manager = Manager

func EnterState():
	var timer = get_tree().create_timer(5,true,false,true)
	await timer.timeout
	get_tree().reload_current_scene()
	manager.ChangeGameState(GameState.TitleScreen)
	
func ExitState():
	pass

func Draw():
	pass
	
func Update(delta: float):
	pass
