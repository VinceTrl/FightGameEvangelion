extends CharacterState

@export var stealRaycast:RayCast3D
@export var stealDelay:float = 0.5
@export var audio:AudioStreamRandomizer


func EnterState():
	stateName = "STEAL"
	character.movement.currentDirection = Vector3.ZERO # stop moving
	
	StealTarget()
	await get_tree().create_timer(stealDelay).timeout

	character.SetSafeLocation()
	#character.Teleport(character.GetSafeLocation())
	
	character.ChangeState(stateMachine.Idle)
	
func ExitState():
	pass
	
func ProcessState(delta: float):
	HandleAnimation()
	pass
	
func PhysicsProcessState(delta: float):
	pass
	
func StealTarget():
	if(stealRaycast.is_colliding()):
		var target = stealRaycast.get_collider()
		if(target.owner is Block):
			character.StealTarget(target.owner,target)
			GlobalSFX.EmitSound(audio,-10,character.global_position)
		elif(target is CharacterBody3D):
			if(target is PlayerCharacter):
				target.ChangeState(target.States.Stun)
			character.StealTarget(target,target)
			GlobalSFX.EmitSound(audio,-10,character.global_position)
			
			
			
func HandleAnimation():
	if(character.movement.isMoving):
		if(character.isHoldingItem and character.animation.current_animation != "WalkWithItem"):
			character.animation.play("WalkWithItem")
		elif(!character.isHoldingItem and character.animation.current_animation != "Walk"):
			character.animation.play("Walk")
	else:
		if(character.isHoldingItem and character.animation.current_animation != "Hold"):
			character.animation.play("Hold")
		elif(!character.isHoldingItem and character.animation.current_animation != "Idle"):
			character.animation.play("Idle")
