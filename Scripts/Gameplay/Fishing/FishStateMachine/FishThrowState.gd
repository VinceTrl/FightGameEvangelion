extends FishState

func EnterState():
	Name = "Throw"
	FishingRodOwner.hook.ThrowHook()
	HandleAnimations()
	
func ExitState():
	pass

func Draw():
	pass
	
func Update(delta: float):
	pass

func HandleAnimations():
	FishingRodOwner.fishing_rod_animation.play("Throwing")
	await FishingRodOwner.fishing_rod_animation.animation_finished
	FishingRodOwner.ChangeState(FishingRodOwner.fishing_states.Fish)
