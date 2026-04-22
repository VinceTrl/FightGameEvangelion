extends CharacterState

@export var targetRaycast:RayCast3D
@export var dropDelay:float = 1.0


func EnterState():
	stateName = "DROP"
	character.movement.currentDirection = Vector3.ZERO # stop moving
	
	character.DropItem()
	character.animation.play("Idle")
	
	await get_tree().create_timer(dropDelay).timeout
	character.SetSafeLocation()
	character.Teleport(character.GetSafeLocation())
	character.ChangeState(stateMachine.Idle)
	
func ExitState():
	pass
	
func ProcessState(delta: float):
	pass
	
func PhysicsProcessState(delta: float):
	pass
