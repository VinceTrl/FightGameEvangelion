extends CharacterState

@export var wanderTimeMin:float = 0.5
@export var wanderTimeMax:float = 1.5

@export var raycasts:Array[RayCast3D]

var timer:SceneTreeTimer

func EnterState():
	stateName = "WANDER"
	character.movement.currentDirection = Vector3.ZERO # stop moving

	SetRandomDirection()
	var time := randf_range(wanderTimeMin,wanderTimeMin)
	timer = get_tree().create_timer(time)

func ExitState():
	pass
	
func ProcessState(delta: float):
	CheckObstacles()
	if(timer.time_left <= 0.0):
		NextState()
	pass
	
func PhysicsProcessState(delta: float):
	pass
	
func CheckObstacles():
	for raycast in raycasts:
		if(raycast.is_colliding()):
			character.movement.currentDirection = -character.movement.currentDirection
			return

func SetRandomDirection():
	var direction := Vector3.RIGHT
	var rng = randf_range(-1,1)
	if(rng <= 0.0):
		direction = Vector3.LEFT
	character.movement.currentDirection = direction
	
func NextState():
	#change State
	if(character.currentState == self):
		if(character.isHoldingItem):
			character.ChangeState(stateMachine.Drop) 
		else:
			character.ChangeState(stateMachine.Steal)
