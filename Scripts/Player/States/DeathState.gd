extends PlayerState

@export var glitchEffect: GlitchParameters
@onready var sfx_mi: AudioStreamPlayer3D = $"../../PlayerAudio/Sfx_Mi"

func EnterState():
	Name = "Death"
	Player.velocity = Vector3.ZERO
	Player.emit_signal("OnPlayerDeath")
	Player.Ammo.StopReloadTimer()
	
	Manager.postProcessEffects.GlitchEffect(glitchEffect)
	
	#await get_tree().create_timer(glitchEffect.glitchEffectTime,true,false,true).timeout
	
	Player.animator.play("Death")
	sfx_mi.play()
	Manager.timeManager.slowMotion(0.25,2.0)
	Manager.gameCamera.camShake.AskCamShake("FinalHitShake")
	Manager.gameCamera.CameraZoom(Player,Manager.gameCamera.GetZoomParamFromName("DeathZoom"))
	await Manager.gameCamera.OnZoomEnd
	Manager.gameCamera.RemoveCameraTarget(Player)
	
	
func ExitState():
	pass

func Draw():
	pass
	
func Update(delta: float):
	Player.HandleGravity(delta)
	HandleAnimations()
	
func HandleAnimations():
	Player.HandleFlipH()
	
func DestroyPlayer():
	pass
