extends FishState

func EnterState():
	Name = "Pull"
	HandleAnimations()
	
func ExitState():
	pass

func Draw():
	pass
	
func Update(delta: float):
	pass

func HandleAnimations():
	FishingRodOwner.fishing_rod_animation.play("PullUp")
	await FishingRodOwner.fishing_rod_animation.animation_finished
	FishingRodOwner.ChangeState(FishingRodOwner.fishing_states.Idle)
