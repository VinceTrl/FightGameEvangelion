extends CharacterState

@export var idleTimeMin:float = 0.5
@export var idleTimeMax:float = 1.5

func EnterState():
	stateName = "IDLE"
	character.movement.currentDirection = Vector3.ZERO # stop moving
	HandleAnimation()
	var time := randf_range(idleTimeMin,idleTimeMax)
	await get_tree().create_timer(time).timeout
	if(character.currentState == self):
		character.ChangeState(stateMachine.Wander) #change State
	pass
	
func ExitState():
	pass
	
func ProcessState(delta: float):
	pass
	
func PhysicsProcessState(delta: float):
	pass

func HandleAnimation():
	if(character.isHoldingItem and character.animation.current_animation != "Hold"):
		character.animation.play("Hold")
	elif(!character.isHoldingItem and character.animation.current_animation != "Idle"):
		character.animation.play("Idle")
