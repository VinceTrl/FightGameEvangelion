extends CharacterState



func EnterState():
	stateName = "DEATH"
	character.movement.currentDirection = Vector3.ZERO # stop moving
	character.animation.play("Idle")
	WolfManager.RemoveWolf(character)
	character.queue_free()
	pass
	
func ExitState():
	pass
	
func ProcessState(delta: float):
	pass
	
func PhysicsProcessState(delta: float):
	pass
