extends PyramidHeadState

@export var attackTime:float = 1.0
@export var hitbox:Hitbox
var timer:SceneTreeTimer

func EnterState():
	Name = "Attack"
	Character.movement.currentDirection = Vector3.ZERO
	
	if(Character.flip.IsFacingRight()):
		hitbox.hitDirection = Vector3.RIGHT
	else:
		hitbox.hitDirection = Vector3.LEFT
	
	Character.animation.play("Attack")
	AttackTimer()
		
func AttackTimer():
	timer = get_tree().create_timer(attackTime)
	await timer.timeout
	if(Character.currentState == StateMachine.Attack):
		Character.ChangeState(StateMachine.Idle)

func ExitState():
	hitbox.InactiveHitBox()
	Character.movement.currentDirection = Vector3.ZERO
	
func Update(delta: float):
	pass
