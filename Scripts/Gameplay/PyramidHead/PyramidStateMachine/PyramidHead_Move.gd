extends PyramidHeadState

func EnterState():
	Name = "Move"
	Character.movement.currentDirection = Vector3.RIGHT
	Character.animation.play("PH_AnimationLibrary/Walk")
	
func ExitState():
	Character.movement.currentDirection = Vector3.ZERO
	
func Update(delta: float):
	pass
