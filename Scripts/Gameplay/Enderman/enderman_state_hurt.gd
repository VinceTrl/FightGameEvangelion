extends CharacterState


@export var hurtTime:float = 1.0
@export var deathDelay:float = 0.5

@export_category("Effect")
@export var freezeFrameDuration:float = 0.1
@export var cameraShake:String = "HitShake"
@export var nodeShaker:NodeShaker


var hitbox:Hitbox
var direction:Vector3
var timer:SceneTreeTimer

func EnterState():
	stateName = "HURT"
	character.movement.currentDirection = Vector3.ZERO #stop movement
	
	if(character.lastHitbox):
		hitbox = character.lastHitbox

	#effect
	Manager.timeManager.freezeFrame(0.001,freezeFrameDuration)
	Manager.gameCamera.camShake.AskCamShake(cameraShake)
	nodeShaker.NodeShake()
	
	#character.animation.play("Hurt")
	
	#update health and check death
	character.health.ChangeHealth(-hitbox.damage)
	
	if(character.health.isDead):
		DeathDelay()
	
	#start state timer
	timer = get_tree().create_timer(hurtTime)
	
func ProcessState(delta: float):
	if(timer.time_left <= 0.0):
		character.ChangeState(stateMachine.Idle)
	
	
func DeathDelay():
	await get_tree().create_timer(deathDelay).timeout
	character.ChangeState(stateMachine.Death)
