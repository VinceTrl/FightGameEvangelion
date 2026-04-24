extends CharacterState

@export var howlDuration:float = 1.5
@export var howlScreenDelay:float = 0.5
@export var castSphereShape:CollisionShape3D
@export var howlScreen:Control

func EnterState():
	stateName = "HOWL"
	character.movement.currentDirection = Vector3.ZERO # stop moving
	character.animation.play("Howl")
	castSphereShape.disabled = false
	StartHowlScreen()
	await get_tree().create_timer(howlDuration).timeout
	if(character.currentState == self):
		NextState()
	
func ExitState():
	howlScreen.visible = false
	castSphereShape.disabled = true
	
func ProcessState(delta: float):
	pass
	
func PhysicsProcessState(delta: float):
	pass

func NextState():
	CastWolf()
	character.ChangeState(stateMachine.DashAttack)
	
func CastWolf():
	var bodies:Array[Node3D] = castSphereShape.get_parent().get_overlapping_bodies()
	
	for body in bodies:
		if(body is Wolf):
			body.ReceiveHowl()
			
func StartHowlScreen():
	await get_tree().create_timer(howlScreenDelay).timeout
	howlScreen.visible = true
