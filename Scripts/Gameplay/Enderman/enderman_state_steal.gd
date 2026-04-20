extends CharacterState

@export var targetRaycast:RayCast3D
@export var stealDelay:float = 0.5
@export var targetClass:Variant


func EnterState():
	stateName = "STEAL"
	character.movement.currentDirection = Vector3.ZERO # stop moving
	
	StealTarget()
	await get_tree().create_timer(stealDelay).timeout
	#character.SetTeleportToSafeLocation()
	#character.Teleport()
	character.ChangeState(stateMachine.Drop)
	
func ExitState():
	pass
	
func ProcessState(delta: float):
	pass
	
func PhysicsProcessState(delta: float):
	pass
	
func StealTarget():
	if(targetRaycast.is_colliding()):
		var target = targetRaycast.get_collider()
		if(target.owner is Block):
			character.StealTarget(target.owner)
		elif(target is CharacterBody3D):
			character.StealTarget(target)
