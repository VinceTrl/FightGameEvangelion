extends PlayerState

func EnterState():
	Name = "Locked"
	Player.isInvicible = true
	Player.velocity = Vector3.ZERO
	
func ExitState():
	Player.isInvicible = false

func Draw():
	pass
	
func Update(delta: float):
	pass

func HandleAnimations():
	pass
