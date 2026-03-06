extends PyramidHeadState

@export var duration:float = 3.0
var timer:SceneTreeTimer

func EnterState():
	Name = "Dance"
	Character.movement.currentDirection = Vector3.ZERO
	#Character.animation.play("PH_AnimationLibrary/Dance")
	RandomDance()
	StateTimer()
	
func ExitState():
	pass
	
func Update(delta: float):
	pass

func StateTimer():
	timer = get_tree().create_timer(duration)
	await timer.timeout
	if(Character.currentState == StateMachine.Dance):
		Character.ChangeState(StateMachine.Idle)
		
func RandomDance():
	var rng = randi_range(1,3)
	match rng:
		1:
			Character.animation.play("PH_AnimationLibrary/Dance")
		2:
			Character.animation.play("PH_AnimationLibrary/Dance_HipHop")
		3:
			Character.animation.play("PH_AnimationLibrary/Dance_Step")
	
	pass
