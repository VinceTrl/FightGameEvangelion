extends PlayerState

@export var glitchEffect: GlitchParameters
@onready var sfx_mi: AudioStreamPlayer3D = $"../../PlayerAudio/Sfx_Mi"
@onready var sfx_kiki: AudioStreamPlayer3D = $"../../PlayerAudio/Sfx_Kiki"
@onready var sfx_hurt: AudioStreamPlayer3D = $"../../PlayerAudio/Sfx_Hurt"

const SD_ATTACK_IMPACT = preload("res://Assets/Sounds/SFX/DoudouSFX/SD_attackIMPACT.wav")
const SD_IMPACTPROJECTILE = preload("res://Assets/Sounds/SFX/DoudouSFX/SD_impactprojectile.wav")
const VFX_2D_FALL = preload("res://Scenes/VFX/VFX2D/vfx_2d_fall.tscn")

func EnterState():
	Name = "Death"
	Player.velocity = Vector3.ZERO
	Player.emit_signal("OnPlayerDeath")
	Player.canChangeState = false
	Player.Ammo.StopReloadTimer()
	
	Manager.postProcessEffects.GlitchEffect(glitchEffect)
	#await get_tree().create_timer(glitchEffect.glitchEffectTime,true,false,true).timeout
	Manager.postProcessEffects.GlitchEffect(glitchEffect)
	StartBackgroundEffect()

	Manager.timeManager.slowMotion(0.15,1.0)
	PlayDeathAnimation()
	PlayDeathSFX()
	Player.nodeShaker.NodeShake(0.1,0.5)
	Manager.gameCamera.camShake.AskCamShake("FinalHitShake")
	
	if(Player.lastHitbox.type != Hitbox.DamageType.Volume):
		Manager.gameCamera.CameraZoom(Player,Manager.gameCamera.GetZoomParamFromName("DeathZoom"))
		await Manager.gameCamera.OnZoomEnd
	else:
		var vfx = VFX_2D_FALL.instantiate()
		vfx.global_position = Player.global_position
		get_tree().current_scene.add_child(vfx)

	StopBackgroundEffect()
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
	#Player.animator.ignoreTimeScale = true
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
		
func StartBackgroundEffect():
	if(Player.lastHitbox.type != Hitbox.DamageType.Melee): return
	
	#Manager.gameManager.currentMap.SetEnviroVisibility(false)
	#Manager.gameManager.currentStage.SetLevelVisibility(false)
	Manager.gameManager.death_background.SetBackgroundOnPlayer(Player)
	
func StopBackgroundEffect():
	#Manager.gameManager.currentMap.SetEnviroVisibility(true)
	#Manager.gameManager.currentStage.SetLevelVisibility(true)
	Manager.gameManager.death_background.HideBackground()
