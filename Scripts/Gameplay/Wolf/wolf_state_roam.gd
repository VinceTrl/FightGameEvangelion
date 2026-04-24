extends CharacterState

@export var roamTimeMin:float = 3.0
@export var roamTimeMax:float = 5.5

@export var backRaycasts:Array[RayCast3D]
@export var frontRaycasts:Array[RayCast3D]

func EnterState():
	stateName = "ROAM"
	character.movement.currentDirection = Vector3.ZERO # stop moving
	SetRandomDirection()
	
	character.animation.play("Walk")
	
	var time := randf_range(roamTimeMin,roamTimeMax)
	await get_tree().create_timer(time).timeout
	if(character.currentState == self):
		character.ChangeState(stateMachine.Idle) #change State
	pass
	
func ExitState():
	pass
	
func ProcessState(delta: float):
	CheckObstacles()
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
