extends PyramidHeadState

@export var roamTimeMin:float = 3.0
@export var roamTimeMax:float = 7.0
var roamTime:float = 5.0
var timer:SceneTreeTimer

func EnterState():
	Name = "Roam"
	Character.animation.play("PH_AnimationLibrary/Walk")
	SetRandomDirection()
	RoamTimer()
		
func SetRandomDirection():
	var ranDir := randf_range(-1,1)
	if(ranDir >= 0.0):
		Character.movement.currentDirection = Vector3.RIGHT
	else:
		Character.movement.currentDirection = Vector3.LEFT
		
func RoamTimer():
	roamTime = randf_range(roamTimeMin,roamTimeMax)
	timer = get_tree().create_timer(roamTime)
	await timer.timeout
	if(Character.currentState == StateMachine.Roam):
		Character.ChangeState(StateMachine.Idle)

func ExitState():
	#Character.movement.currentDirection = Vector3.ZERO
	pass
	
func Update(delta: float):
	Character.ProcessObstacleDetection()
	Character.ProcessGroundDetection()
	Character.ProcessTargetDetection()
	Character.ProcessFlip()
	pass
