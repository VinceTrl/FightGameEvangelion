extends CharacterState

@export var idleTimeMin:float = 0.5
@export var idleTimeMax:float = 1.5

func EnterState():
	stateName = "IDLE"
	character.movement.currentDirection = Vector3.ZERO # stop moving
	var time := randf_range(idleTimeMin,idleTimeMax)
	await get_tree().create_timer(time).timeout
	if(character.currentState == self):
		character.ChangeState(stateMachine.Steal) #change State
	pass
	
func ExitState():
	pass
	
func ProcessState(delta: float):
	pass
	
func PhysicsProcessState(delta: float):
	pass
