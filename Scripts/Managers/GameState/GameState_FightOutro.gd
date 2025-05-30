extends GameStates

func _ready():
	state = GameState.FightOutro
	manager = Manager

func EnterState():
	manager.emit_signal("OnFightFinish")
	var timer = get_tree().create_timer(1.5,true,false,true)
	await timer.timeout
	#get_tree().reload_current_scene()
	manager.ChangeGameState(GameState.FightResult)
	
func ExitState():
	pass

func Draw():
	pass
	
func Update(delta: float):
	pass
