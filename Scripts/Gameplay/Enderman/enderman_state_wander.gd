extends CharacterState

@export var wanderTimeMin:float = 0.5
@export var wanderTimeMax:float = 1.5

@export var frontRaycasts:Array[RayCast3D]
@export var backRaycasts:Array[RayCast3D]

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
	HandleAnimation()
	CheckObstacles()
	if(timer.time_left <= 0.0):
		NextState()
	pass
	
func PhysicsProcessState(delta: float):
	#CheckObstacles()
	pass
	
func CheckObstacles():
	var obstacleOnBack := false
	var obstacleOnFront := false
	
	for raycast in backRaycasts:
		if(raycast.is_colliding()):
			obstacleOnBack = true
	
	for raycast in frontRaycasts:
		if(raycast.is_colliding()):
			obstacleOnFront = true
			
	if(obstacleOnFront and !obstacleOnBack and character.is_on_floor()):
		character.movement.currentDirection = -character.movement.currentDirection
	elif(obstacleOnFront and obstacleOnBack):
		character.movement.Jump()

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
			
func HandleAnimation():
	if(character.movement.isMoving):
		if(character.isHoldingItem and character.animation.current_animation != "WalkWithItem"):
			character.animation.play("WalkWithItem")
		elif(!character.isHoldingItem and character.animation.current_animation != "Walk"):
			character.animation.play("Walk")
	else:
		if(character.isHoldingItem and character.animation.current_animation != "Hold"):
			character.animation.play("Hold")
		elif(!character.isHoldingItem and character.animation.current_animation != "Idle"):
			character.animation.play("Idle")
