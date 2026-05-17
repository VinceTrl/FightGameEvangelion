extends CharacterState

const CREEPER_DEATH = preload("uid://b5doudtkca4re")


func EnterState():
	stateName = "CREEPER DEATH"
	character.movement.currentDirection = Vector3.ZERO #stop movement
	GlobalSFX.EmitSound(CREEPER_DEATH,-10,character.global_position)
	character.queue_free()
	pass
	
func ExitState():
	pass
	
func ProcessState(delta: float):
	pass
	
func PhysicsProcessState(delta: float):
	pass
