extends PyramidHeadState

func EnterState():
	Name = "Move"
	Character.movement.currentDirection = Vector3.RIGHT
	Character.animation.play("Walk")
	
func ExitState():
	Character.movement.currentDirection = Vector3.ZERO
	
func Update(delta: float):
	pass
