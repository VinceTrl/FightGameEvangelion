extends PlayerState


@export var hurtDuration = 0.1
@export var damageGlitchEffect: GlitchParameters
@onready var hurtTimer: Timer = $"../../Timers/HurtTimer"
@onready var ground_location: Marker3D = $"../../GroundLocation"

@onready var sfx_hurt: AudioStreamPlayer3D = $"../../PlayerAudio/Sfx_Hurt"
@onready var sfx_mi: AudioStreamPlayer3D = $"../../PlayerAudio/Sfx_Mi"

const VFX_2D_IMPACT_MEDIUM = preload("res://Scenes/VFX/VFX2D/vfx_2d_impact_medium.tscn")
const SD_ATTACK_IMPACT = preload("res://Assets/Sounds/SFX/DoudouSFX/SD_attackIMPACT.wav")
const SD_IMPACTPROJECTILE = preload("res://Assets/Sounds/SFX/DoudouSFX/SD_impactprojectile.wav")

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
	
	var vfx = VFX_2D_IMPACT_MEDIUM.instantiate()
	vfx.global_position = Player.global_position
	get_tree().current_scene.add_child(vfx)
	
	#Hurt effects
	Manager.timeManager.freezeFrame(0.001,0.2)
	Player.sprite.HitColorEffect()
	Player.nodeShaker.NodeShake()
	Manager.gameCamera.camShake.AskCamShake("HitShake")
	Manager.gameCamera.FocusTargetZoom(Player,Manager.gameCamera.GetZoomParamFromName("HitZoom"))
	Manager.gameManager.vibrationManager.LaunchVibration(Player.playerID-1,"HurtVibration")
	Manager.postProcessEffects.GlitchEffect(damageGlitchEffect)
	
	#Hurt audio
	if (Player.lastHitbox != null):
		if(Player.lastHitbox.type == Hitbox.DamageType.Melee):
			sfx_hurt.stream = SD_ATTACK_IMPACT
		else:
			sfx_hurt.stream = SD_IMPACTPROJECTILE
	
	sfx_hurt.play()
	#await sfx_hurt.finished
	sfx_mi.play()
	
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
