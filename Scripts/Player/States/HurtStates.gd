extends PlayerState

@export var minHurtSpeed = 0.5
@export var maxHurtSpeed = 4.0
@export var hurtDuration = 0.1 #not used
@export var hurtSpeedCurve: Curve
@export var damageGlitchEffect: GlitchParameters
@onready var hurtTimer: Timer = $"../../Timers/HurtTimer"

var hurtTime = 0.0
var direction = Vector3.ZERO
var hitbox: Hitbox = null

func EnterState():
	Name = "Hurt"
	Player.velocity = Vector3.ZERO #stop player
	Player.animator.play("Hurt")
	if(Player.lastHitbox != null): hitbox = Player.lastHitbox
	SetDirection()
	hurtTime = Player.animator.current_animation_length
	hurtTimer.start(hurtTime)
	Player.Ammo.AddTime()
	Manager.timeManager.freezeFrame(0.001,0.2)
	Player.sprite.HitColorEffect()
	Player.nodeShaker.NodeShake()
	Manager.gameCamera.camShake.AskCamShake("HitShake")
	Manager.gameCamera.FocusTargetZoom(Player,Manager.gameCamera.GetZoomParamFromName("HitZoom"))
	Manager.gameManager.vibrationManager.LaunchVibration(Player.playerID-1,"HurtVibration")
	Manager.postProcessEffects.GlitchEffect(damageGlitchEffect)
	
func ExitState():
	pass

func Draw():
	pass
	
func Update(delta: float):
	Player.HandleGravity(delta)
	HandleHurtSpeed()
	HandleAnimations()
	
func HandleAnimations():
	Player.HandleFlipH()
	
func Recover():
	Player.ChangeState(States.Idle)
	
func SetDirection():
	if(hitbox == null): 
		direction = Vector3(-Player.facing,0,0)
	else:
		#print("SetDirection ")
		direction = Player.global_position - hitbox.global_position
		direction = direction.normalized()
	
func HandleHurtSpeed():
	if hurtTimer.time_left <= 0: return
	
	Player.velocity = direction * GetHurtSpeed()
	
func GetHurtSpeed() -> float:
	if(hurtTimer.time_left == 0): return 0.0
	
	var _timeProgress = hurtTime - hurtTimer.time_left
	var _progressRatio = _timeProgress/hurtTime
	var _curveValue = hurtSpeedCurve.sample(_progressRatio);
	var _hurtSpeed = lerp(minHurtSpeed,maxHurtSpeed,_curveValue)
	
	return _hurtSpeed
	
