extends CharacterState

@export var howlDuration:float = 1.5
@export var howlScreenDelay:float = 0.5
@export var howlScreen:Control

func EnterState():
	stateName = "HOWL"
	character.movement.currentDirection = Vector3.ZERO # stop moving
	character.animation.play("Howl")
	StartHowlScreen()
	await get_tree().create_timer(howlDuration).timeout
	if(character.currentState == self):
		NextState()
	
func ExitState():
	howlScreen.visible = false
	
func ProcessState(delta: float):
	pass
	
func PhysicsProcessState(delta: float):
	pass

func NextState():
	WolfManager.SpreadHowl()
	character.ChangeState(stateMachine.DashAttack)

func StartHowlScreen():
	await get_tree().create_timer(howlScreenDelay).timeout
	howlScreen.visible = true
