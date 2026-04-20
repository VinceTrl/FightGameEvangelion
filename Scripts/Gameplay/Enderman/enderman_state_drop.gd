extends CharacterState

@export var targetRaycast:RayCast3D
@export var dropDelay:float = 0.5


func EnterState():
	stateName = "DROP"
	character.movement.currentDirection = Vector3.ZERO # stop moving
	
	character.DropItem()
	await get_tree().create_timer(dropDelay).timeout
	character.ChangeState(stateMachine.Idle)
	
func ExitState():
	pass
	
func ProcessState(delta: float):
	pass
	
func PhysicsProcessState(delta: float):
	pass
