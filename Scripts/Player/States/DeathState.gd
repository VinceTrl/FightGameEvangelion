extends PlayerState

@export var glitchEffect: GlitchParameters
@onready var sfx_mi: AudioStreamPlayer3D = $"../../PlayerAudio/Sfx_Mi"
@onready var sfx_kiki: AudioStreamPlayer3D = $"../../PlayerAudio/Sfx_Kiki"
@onready var sfx_hurt: AudioStreamPlayer3D = $"../../PlayerAudio/Sfx_Hurt"

const SD_ATTACK_IMPACT = preload("res://Assets/Sounds/SFX/DoudouSFX/SD_attackIMPACT.wav")
const SD_IMPACTPROJECTILE = preload("res://Assets/Sounds/SFX/DoudouSFX/SD_impactprojectile.wav")

func EnterState():
	Name = "Death"
	Player.velocity = Vector3.ZERO
	Player.emit_signal("OnPlayerDeath")
	Player.Ammo.StopReloadTimer()
	
	Manager.postProcessEffects.GlitchEffect(glitchEffect)
	
	#await get_tree().create_timer(glitchEffect.glitchEffectTime,true,false,true).timeout
	
	PlayDeathAnimation()
	PlayDeathSFX()
	Manager.timeManager.slowMotion(0.25,2.0)
	Manager.gameCamera.camShake.AskCamShake("FinalHitShake")
	Manager.gameCamera.CameraZoom(Player,Manager.gameCamera.GetZoomParamFromName("DeathZoom"))
	await Manager.gameCamera.OnZoomEnd
	Manager.gameCamera.RemoveCameraTarget(Player)
	Manager.gameCamera.CameraZoom(Manager.gameManager.GetPlayerOpponent(Player),Manager.gameCamera.GetZoomParamFromName("VictoryZoom"))
	
func ExitState():
	pass

func Draw():
	pass
	
func Update(delta: float):
	Player.HandleGravity(delta)
	HandleAnimations()
	
func HandleAnimations():
	#Player.HandleFlipH()
	pass
	
func DestroyPlayer():
	pass
	
func PlayDeathAnimation():
	Player.animator.play("Death")
	await Player.animator.animation_finished
	Player.animator.play("DeathLoop")
	
func PlayDeathSFX():
	var hitbox = Player.lastHitbox
	
	if(hitbox != null):
		if(hitbox.type == Hitbox.DamageType.Melee):
			sfx_hurt.stream = SD_ATTACK_IMPACT
		else:
			sfx_hurt.stream = SD_IMPACTPROJECTILE
	
		if(hitbox.type == Hitbox.DamageType.Volume):
			sfx_kiki.play()
		else:
			sfx_hurt.play()
			sfx_mi.play()
	else:
		sfx_mi.play()
