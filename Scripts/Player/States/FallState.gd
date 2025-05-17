extends PlayerState

func EnterState():
	Name = "Fall"
	Player.animator.play("Fall")
	
func ExitState():
	pass

func Draw():
	pass
	
func Update(delta: float):
	Player.HandleGravity(delta,GetFallGravity())
	Player.HorizontalMovement()
	Player.HandleLanding()
	Player.HandleJumpBuffer()
	
	Player.HandleJump()
	Player.HandleDash()
	Player.HandleAirAttack()
	Player.HandleShoot()
	
	HandleAnimations()
	
func HandleAnimations():
	#Player.animator.play("Fall")
	Player.HandleFlipH()
	
func HandleFallInput():
	#Player.animator.play("Fall")
	Player.HandleFlipH()
	
func GetFallGravity() -> float:
	#Player.animator.play("Fall")
	if(Player.keyDown):
		return Player.fallGravity * Player.fallGravityMultiplier
	else: 
		return Player.fallGravity
