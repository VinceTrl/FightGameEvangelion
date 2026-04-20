extends CharacterState

@export var teleportDelay:float = 0.5


func EnterState():
	stateName = "TELEPORT"
	character.movement.currentDirection = Vector3.ZERO # stop moving

	if(character.nextTeleportPosition == Vector3.ZERO):
		print("ENDERMAN : no teleport set up")
		character.ChangeState(stateMachine.Idle) #change State
	else:
		Teleport()
	
func ExitState():
	pass
	
func ProcessState(delta: float):
	pass
	
func PhysicsProcessState(delta: float):
	pass
	
func Teleport():
	await get_tree().create_timer(teleportDelay).timeout
	character.global_position = character.nextTeleportPosition
	character.ChangeState(stateMachine.Idle)
