extends CharacterState

@export var stealRaycast:RayCast3D
@export var stealDelay:float = 0.5


func EnterState():
	stateName = "STEAL"
	character.movement.currentDirection = Vector3.ZERO # stop moving
	
	StealTarget()
	await get_tree().create_timer(stealDelay).timeout

	character.SetSafeLocation()
	character.Teleport(character.GetSafeLocation())
	
	character.ChangeState(stateMachine.Idle)
	
func ExitState():
	pass
	
func ProcessState(delta: float):
	pass
	
func PhysicsProcessState(delta: float):
	pass
	
func StealTarget():
	if(stealRaycast.is_colliding()):
		var target = stealRaycast.get_collider()
		if(target.owner is Block):
			character.StealTarget(target.owner)
		elif(target is CharacterBody3D):
			character.StealTarget(target)
