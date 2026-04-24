extends CharacterState

@export var idleTimeMin:float = 0.5
@export var idleTimeMax:float = 1.5

func EnterState():
	stateName = "IDLE"
	character.movement.currentDirection = Vector3.ZERO # stop moving
	character.animation.play("Idle")
	var time := randf_range(idleTimeMin,idleTimeMax)
	await get_tree().create_timer(time).timeout
	if(character.currentState == self):
		NextState()
	pass
	
func ExitState():
	pass
	
func ProcessState(delta: float):
	pass
	
func PhysicsProcessState(delta: float):
	pass

func NextState():
	if(character.isAngry):
		character.ChangeState(stateMachine.DashAttack)
	else:
		character.ChangeState(stateMachine.Roam)
	pass
