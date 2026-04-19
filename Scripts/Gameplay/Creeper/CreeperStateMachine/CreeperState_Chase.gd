extends CharacterState

@export var igniteRange:float = 0.6
@export var lostTime:float = 1.5
@export var chaseSpeed:float = 0.75
@export var characterCenter:Node3D

var lostTimer:SceneTreeTimer

func EnterState():
	stateName = "CREEPER CHASE"
	character.animation.play("Chase")
	pass
	
func ExitState():
	character.movement.currentDirection = Vector3.ZERO
	character.movement.ResetSpeed()
	character.animation.play("RESET")
	pass
	
func ProcessState(delta: float):
	character.ProcessTargetDetection()
	character.movement.speed = chaseSpeed
	character.movement.currentDirection = GetMoveDirectionToTarget()
	character.flip.ProcessFlip()
	CheckTargetInRange()
	CheckTargetLoss()
	pass
	
func PhysicsProcessState(delta: float):
	pass
	
func GetMoveDirectionToTarget():
	var targetPos = character.targetLastPosition
	var direction:Vector3 = (targetPos - character.global_position)
	return direction.normalized()
	
func CheckTargetInRange():
	var dist := characterCenter.global_position.distance_to(character.targetLastPosition)
	if(dist <= igniteRange):
		character.ChangeState(stateMachine.Ignite)
		
func CheckTargetLoss():
	if(character.targetDetected == false):
		if(lostTimer):
			if(lostTimer.time_left <= 0.0):
				if(character.targetDetected == false and character.currentState == self):
					character.ChangeState(stateMachine.Idle)
				else:
					StartLostTimer()
		else:
			StartLostTimer()
	else:
		if(lostTimer):
			lostTimer = null
		
		
func StartLostTimer():
	lostTimer = get_tree().create_timer(lostTime)
