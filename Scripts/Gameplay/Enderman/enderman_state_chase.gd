extends CharacterState

@export var chaseSpeed:float = 1.0
@export var stealRaycast:RayCast3D
@export var targetReachedThreshold:float = 0.25

var target:Node3D

func EnterState():
	stateName = "CHASE"
	character.movement.currentDirection = Vector3.ZERO # stop moving
	character.movement.speed = chaseSpeed

	target = character.chaseTarget
	
	
	
func ExitState():
	character.movement.ResetSpeed()
	
func ProcessState(delta: float):
	if(!target):
		character.ChangeState(stateMachine.Idle)
		return
		
	ChaseTarget()
	ReachTarget()
	pass
	
func PhysicsProcessState(delta: float):
	pass
	
func ChaseTarget():
	var direction := (target.global_position - character.global_position).normalized()
	character.movement.currentDirection = direction
	
func ReachTarget():
	#if(character.global_position.distance_to(target.global_position) < targetReachedThreshold):
		#character.ChangeState(stateMachine.Steal)
		
	if(stealRaycast.is_colliding()):
		var col = stealRaycast.get_collider()
		if(col == target):
			character.ChangeState(stateMachine.Steal)
	pass
