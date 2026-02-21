extends PyramidHeadState

@export var idleTime:float = 3.0
var timer:SceneTreeTimer

func EnterState():
	Name = "Idle"
	Character.movement.currentDirection = Vector3.ZERO
	IdleTimer()
	
func ExitState():
	pass
	
func Update(delta: float):
	Character.ProcessTargetDetection()
	pass

func IdleTimer():
	timer = get_tree().create_timer(idleTime)
	await timer.timeout
	if(Character.currentState == StateMachine.Idle):
		Character.ChangeState(StateMachine.Roam)
