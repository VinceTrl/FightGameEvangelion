extends CharacterState

@export var hurtTime:float = 1.0
@export var deathDelay:float = 0.5

@export_category("Knockback")
@export var knockbackSpeedMin = 0.5
@export var knockbackSpeedMax = 10.0
@export var knockbackSpeedCurve: Curve
@export var knockbackForceMultiplier: float = 1.0
var currentKnockbackForce = 1.0

@export_category("Effect")
@export var freezeFrameDuration:float = 0.1
@export var cameraShake:String = "HitShake"
@export var nodeShaker:NodeShaker


var hitbox:Hitbox
var direction:Vector3
var timer:SceneTreeTimer

func EnterState():
	stateName = "CREEPER HURT"
	character.movement.currentDirection = Vector3.ZERO #stop movement
	
	if(character.lastHitbox):
		hitbox = character.lastHitbox
		currentKnockbackForce = hitbox.hitForce
		
	SetDirection()

	#effect
	Manager.timeManager.freezeFrame(0.001,freezeFrameDuration)
	Manager.gameCamera.camShake.AskCamShake("HitShake")
	nodeShaker.NodeShake()
	
	if(!character.isIgnited):
		character.animation.play("Hurt")
	
	#update health and check death
	character.health.ChangeHealth(-hitbox.damage)
	if(character.health.isDead):
		DeathDelay()
	
	#start state timer
	timer = get_tree().create_timer(hurtTime)
	
func ExitState():
	pass
	
func ProcessState(delta: float):
	ProcessKnockback()
	pass
	
func PhysicsProcessState(delta: float):
	pass

func SetDirection():
	direction = character.global_position - hitbox.global_position
	direction = direction.normalized()
	
func ProcessKnockback():
	if timer.time_left <= 0:
		character.ChangeState(stateMachine.Idle)
	else:
		character.velocity = direction * GetKnockbackSpeed()
	
func GetKnockbackSpeed() -> float:
	if(timer.time_left == 0): return 0.0
	
	var _timeProgress = hurtTime - timer.time_left
	var _progressRatio = _timeProgress/hurtTime
	var _curveValue = knockbackSpeedCurve.sample(_progressRatio);
	var _knockbackSpeed = lerp(knockbackSpeedMin,knockbackSpeedMax,_curveValue)
	var _currentKnockBackSpeed = _knockbackSpeed * currentKnockbackForce
	
	return _currentKnockBackSpeed
	
func DeathDelay():
	await get_tree().create_timer(deathDelay).timeout
	character.ChangeState(stateMachine.Death)
