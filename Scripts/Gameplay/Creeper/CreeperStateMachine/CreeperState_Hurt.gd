extends CharacterState

@export var hurtTime:float = 1.0
var hitbox:Hitbox

func EnterState():
	stateName = "CREEPER HURT"
	character.movement.currentDirection = Vector3.ZERO #stop movement
	
	if(character.lastHitbox):
		hitbox = character.lastHitbox
		var hp := character.health as HealthComponent
		hp.ChangeHealth(-hitbox.damage)
		if(hp.isDead):
			character.ChangeState(stateMachine.Death)
	
	await get_tree().create_timer(hurtTime).timeout
	character.ChangeState(stateMachine.Idle)
	pass
	
func ExitState():
	pass
	
func ProcessState(delta: float):
	pass
	
func PhysicsProcessState(delta: float):
	pass
