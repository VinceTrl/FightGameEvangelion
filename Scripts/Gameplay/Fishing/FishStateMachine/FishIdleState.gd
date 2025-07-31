extends FishState

func EnterState():
	Name = "Idle"
	HandleAnimations()
	FishingRodOwner.hook.OnPullHookStop()
	
func ExitState():
	pass

func Draw():
	pass
	
func Update(delta: float):
	pass

func HandleAnimations():
	FishingRodOwner.fishing_rod_animation.play("RodUp")
