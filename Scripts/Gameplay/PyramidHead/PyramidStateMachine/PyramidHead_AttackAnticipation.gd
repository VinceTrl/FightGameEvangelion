extends PyramidHeadState

@export var anticipationTime:float = 0.75
@export_range(0.0,1.0,0.01) var attackChance:float = 0.75
var timer:SceneTreeTimer

func EnterState():
	Name = "AttackAnticipation"
	Character.movement.currentDirection = Vector3.ZERO
	Character.animation.play("Attack")
	StateTimer()
		
func StateTimer():
	timer = get_tree().create_timer(anticipationTime)
	await timer.timeout
	if(Character.currentState == StateMachine.AttackAnticipation):
		randomize()
		var rand:float = randf_range(0.0,1.0)
		if(rand <= attackChance):
			Character.ChangeState(StateMachine.Attack)
		else:
			Character.ChangeState(StateMachine.Dance)

func ExitState():
	Character.movement.currentDirection = Vector3.ZERO
	
func Update(delta: float):
	pass
