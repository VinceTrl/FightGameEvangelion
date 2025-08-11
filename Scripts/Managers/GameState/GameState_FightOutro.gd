extends GameStates

@export var resultStateDelay:float = 1.5

func _ready():
	state = GameState.FightOutro
	manager = Manager

func EnterState():
	manager.emit_signal("OnFightFinish")
	var timer = get_tree().create_timer(resultStateDelay,true,false,true)
	await timer.timeout
	#get_tree().reload_current_scene()
	manager.ChangeGameState(GameState.FightResult)
	
func ExitState():
	pass

func Draw():
	pass
	
func Update(delta: float):
	pass
