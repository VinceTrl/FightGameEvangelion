extends PlayerState

func EnterState():
	Name = "Idle"
	Player.animator.play("Idle")
	
	if(Player.is_on_floor()): 
		Player.ResetJump()
		Player.ResetDash()
		Player.ResetAirAttack()
	
func ExitState():
	pass

func Draw():
	pass
	
func Update(delta: float):
	Player.HandleFalling()
	Player.HorizontalMovement()
	Player.HandleJump()
	Player.HandleDash()
	Player.HandleAttack()
	Player.HandleShoot()
	
	if (Player.moveDirectionX != 0):
		Player.ChangeState(States.Run)
	
	HandleAnimations()


func HandleAnimations():
	
	Player.HandleFlipH()
