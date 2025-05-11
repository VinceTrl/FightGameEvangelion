extends PlayerState

func EnterState():
	Name = "Run"
	Player.animator.play("Move")
	
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
	
	
	HandleAnimations()
	HandleIdle()
	

func HandleIdle():
	if (Player.moveDirectionX == 0):
		Player.ChangeState(States.Idle)

func HandleAnimations():
	Player.HandleFlipH()
