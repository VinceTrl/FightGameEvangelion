extends CharacterState

@export var roamTimeMin:float = 1.0
@export var roamTimeMax:float = 3.0
@export var roamSpeed:float = 0.5

func EnterState():
	stateName = "CREEPER ROAM"
	character.movement.speed = roamSpeed
	SetRandomDirection()
	var time := randf_range(roamTimeMin,roamTimeMin)
	await get_tree().create_timer(time).timeout
	if(character.currentState == self):
		character.ChangeState(stateMachine.Idle) #change State
	pass
	
func ExitState():
	character.movement.ResetSpeed()
	pass
	
func ProcessState(delta: float):
	character.ProcessGroundDetection()
	character.ProcessObstacleDetection()
	character.ProcessTargetDetection()
	character.flip.ProcessFlip()
	pass
	
func PhysicsProcessState(delta: float):
	pass
	
func SetRandomDirection():
	var ranDir := randf_range(-1,1)
	if(ranDir >= 0.0):
		character.movement.currentDirection = Vector3.RIGHT
	else:
		character.movement.currentDirection = Vector3.LEFT
