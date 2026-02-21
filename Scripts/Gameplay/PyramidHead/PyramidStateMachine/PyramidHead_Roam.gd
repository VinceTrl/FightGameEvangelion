extends PyramidHeadState

@export var roamTime:float = 5.0
var timer:SceneTreeTimer

func EnterState():
	Name = "Roam"
	SetRandomDirection()
	RoamTimer()
		
func SetRandomDirection():
	var ranDir := randf_range(-1,1)
	if(ranDir >= 0.0):
		Character.movement.currentDirection = Vector3.RIGHT
	else:
		Character.movement.currentDirection = Vector3.LEFT
		
func RoamTimer():
	timer = get_tree().create_timer(roamTime)
	await timer.timeout
	if(Character.currentState == StateMachine.Roam):
		Character.ChangeState(StateMachine.Idle)

func ExitState():
	Character.movement.currentDirection = Vector3.ZERO
	
func Update(delta: float):
	Character.ProcessObstacleDetection()
	Character.ProcessGroundDetection()
	Character.ProcessTargetDetection()
	Character.ProcessFlip()
	pass
