extends PlayerState

func EnterState():
	Name = "Stun"
	
	Player.velocity = Vector3.ZERO
	
	Player.animator.play("Taunt")
	
	Player.ResetJump()
	Player.ResetDash()
	Player.ResetAirAttack()
	
func ExitState():
	pass

func Draw():
	pass
	
func Update(delta: float):
	HandleAnimations()

func HandleAnimations():
	Player.HandleFlipH()
