extends PlayerState

@export var knockbackSpeedMin = 0.5
@export var knockbackSpeedMax = 10.0
@export var knockbackDuration = 0.25
@export var knockbackSpeedCurve: Curve
@export var knockbackForceMultiplier: float
@onready var knockback_timer: Timer = $"../../Timers/KnockbackTimer"

var knockbackTime = 0.0
var direction = Vector3.ZERO
var hitbox: Hitbox = null
var currentKnockbackForce = 1.0

func EnterState():
	Name = "Knockback"
	Player.velocity = Vector3.ZERO #stop player
	#Player.animator.play("Hurt")
	if(Player.lastHitbox != null): hitbox = Player.lastHitbox
	SetDirection()
	
	knockbackTime = knockbackDuration
	knockback_timer.start(knockbackTime)
	
func ExitState():
	pass

func Draw():
	pass
	
func Update(delta: float):
	Player.HandleGravity(delta)
	HandleKnockbackSpeed()
	HandleAnimations()
	
func HandleAnimations():
	Player.HandleFlipH()
	
func SetDirection():
	if(hitbox == null): 
		direction = Vector3(-Player.facing,0,0)
	else:
		#print("SetDirection ")
		direction = Player.global_position - Player.lastHitLocation
		direction = direction.normalized()
	
func HandleKnockbackSpeed():
	if knockback_timer.time_left <= 0: 
		Player.ChangeState(States.Idle)
	else:
		Player.velocity = direction * GetKnockbackSpeed()
	
func GetKnockbackSpeed() -> float:
	if(knockback_timer.time_left == 0): return 0.0
	
	var _timeProgress = knockbackTime - knockback_timer.time_left
	var _progressRatio = _timeProgress/knockbackTime
	var _curveValue = knockbackSpeedCurve.sample(_progressRatio);
	var _knockbackSpeed = lerp(knockbackSpeedMin,knockbackSpeedMax,_curveValue)
	var _currentKnockBackSpeed = _knockbackSpeed * currentKnockbackForce
	
	return _currentKnockBackSpeed
	
