extends PyramidHeadState

func EnterState():
	Name = "Move"
	Character.movement.currentDirection = Vector3.RIGHT
	
func ExitState():
	Character.movement.currentDirection = Vector3.ZERO
	
func Update(delta: float):
	pass
