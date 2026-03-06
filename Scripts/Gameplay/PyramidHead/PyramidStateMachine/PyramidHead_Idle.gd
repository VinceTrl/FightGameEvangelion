extends PyramidHeadState

@export var idleTimeMin:float = 1.0
@export var idleTimeMax:float = 3.0
var idleTime:float = 3.0

var timer:SceneTreeTimer

func EnterState():
	Name = "Idle"
	Character.movement.currentDirection = Vector3.ZERO
	Character.animation.play("PH_AnimationLibrary/Idle")
	IdleTimer()
	
func ExitState():
	pass
	
func Update(delta: float):
	Character.ProcessTargetDetection()
	pass

func IdleTimer():
	idleTime = randf_range(idleTimeMin,idleTimeMax)
	timer = get_tree().create_timer(idleTime)
	await timer.timeout
	if(Character.currentState == StateMachine.Idle):
		Character.ChangeState(StateMachine.Roam)
