extends PlayerState

func EnterState():
	Name = "Death"
	Player.velocity = Vector3.ZERO
	Player.animator.play("Death")
	Player.emit_signal("OnPlayerDeath")
	Player.Ammo.StopReloadTimer()
	Manager.timeManager.slowMotion(0.25,2.0)
	Manager.gameCamera.camShake.AskCamShake("FinalHitShake")
	Manager.gameCamera.CameraZoom(Player,Manager.gameCamera.GetZoomParamFromName("DeathZoom"))
	
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
