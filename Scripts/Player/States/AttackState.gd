extends PlayerState

var attackInAir = false

func EnterState():
	Name = "Attack"
	
	#Player.velocity.y = 0
	var _attackDir = Player.GetAttackDirection()
	Player.velocity = Player.velocity / 2
	Player.velocity += _attackDir.normalized() * Player.attackSpeed
	
	Player.SetSpriteOffset_Attack()
	Player.animator.play("Attack")
	Player.emit_signal("OnPlayerAttack")
	
func ExitState():
	pass

func Draw():
	pass
	
func Update(delta: float):
	#Player.HandleGravity(Player.attackGravity)
	#Player.HorizontalMovement()
	Player.HandleAttackBuffer()
	HandleAnimations()
	
	
	
func AttackFinished():
	Player.velocity *= Player.attackSpeedMomentum
	
	if(Player.is_on_floor()): 
		Player.ChangeState(States.Idle)
	else: 
		Player.ChangeState(States.Fall)
	
	#if (Player.is_on_floor()): Player.ChangeState(States.Idle)
	#else: Player.ChangeState(States.Fall)
		
	
	

func HandleAnimations():
	#Player.animator.play("Attack")
	Player.HandleFlipH()
	
