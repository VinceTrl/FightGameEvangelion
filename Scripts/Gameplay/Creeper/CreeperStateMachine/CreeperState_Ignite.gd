extends CharacterState

@export var igniteTime:float = 1.25
@export var igniteAudio:AudioStream
var lostTimer:SceneTreeTimer

func EnterState():
	stateName = "CREEPER IGNITE"
	character.movement.currentDirection = Vector3.ZERO #stop movement
	character.animation.play("Ignite")
	GlobalSFX.EmitSound(igniteAudio,-10,character.global_position)
	character.isIgnited = true
	await get_tree().create_timer(igniteTime).timeout
	character.ChangeState(stateMachine.Explode)
	pass
	
func ExitState():
	pass
	
func ProcessState(delta: float):
	pass
	
func PhysicsProcessState(delta: float):
	pass
	
func GetMoveDirectionToTarget():
	var targetPos = character.targetLastPosition
	var direction:Vector3 = (targetPos - character.global_position)
	return direction.normalized()
	
