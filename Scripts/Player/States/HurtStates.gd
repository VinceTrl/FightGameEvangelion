extends PlayerState


@export var hurtDuration = 0.1
@export var damageGlitchEffect: GlitchParameters
@onready var hurtTimer: Timer = $"../../Timers/HurtTimer"

var hurtTime = 0.0
var direction = Vector3.ZERO
var hitbox: Hitbox = null

func EnterState():
	Name = "Hurt"
	Player.velocity = Vector3.ZERO #stop player
	Player.animator.play("Hurt")
	
	hurtTime = hurtDuration
	hurtTimer.start(hurtTime)
	Player.Ammo.AddTime()
	
	#Hurt effects
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
	HandleHurtState()
	HandleAnimations()
	
func HandleAnimations():
	Player.HandleFlipH()
	
func Recover():
	Player.ChangeState(States.Idle)
	
func HandleHurtState():
	if hurtTimer.time_left <= 0: 
		Player.ChangeState(States.Knockback)
		print("GOES TO KNOCKBACK")
