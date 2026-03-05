extends PyramidHeadState

@export var attackTime:float = 1.0
@export var attackMoveSpeed:float = 3.0
@export var hitbox:Hitbox
var timer:SceneTreeTimer

func EnterState():
	Name = "Attack"
	Character.movement.currentDirection = Vector3.ZERO
	
	if(Character.flip.IsFacingRight()):
		hitbox.hitDirection = Vector3.RIGHT
	else:
		hitbox.hitDirection = Vector3.LEFT
	
	#Character.animation.play("Attack")
	AttackTimer()
		
func AttackTimer():
	timer = get_tree().create_timer(attackTime)
	await timer.timeout
	if(Character.currentState == StateMachine.Attack):
		Character.ChangeState(StateMachine.Idle)
		
		
#function called in animation
func StartAttackMovement():
	Character.movement.speed = attackMoveSpeed
	Character.movement.currentDirection = hitbox.hitDirection
	
#function called in animation
func StopAttackMovement():
	Character.movement.ResetSpeed()
	Character.movement.currentDirection = Vector3.ZERO

func ExitState():
	hitbox.InactiveHitBox()
	Character.movement.currentDirection = Vector3.ZERO
	
func Update(delta: float):
	pass
