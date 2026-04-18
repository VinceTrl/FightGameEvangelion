extends CharacterState

func EnterState():
	stateName = "CREEPER DEATH"
	character.movement.currentDirection = Vector3.ZERO #stop movement
	character.queue_free()
	pass
	
func ExitState():
	pass
	
func ProcessState(delta: float):
	pass
	
func PhysicsProcessState(delta: float):
	pass
