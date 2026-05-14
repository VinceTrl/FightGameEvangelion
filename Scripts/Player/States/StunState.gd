extends PlayerState

const PHYSICS_SPEAR_P1 = preload("uid://v5unfgtoa4w0")
const PHYSICS_SPEAR_P2 = preload("uid://caxqeic6uhe0m")


func EnterState():
	Name = "Stun"
	
	Player.velocity = Vector3.ZERO
	
	Player.animator.play("Taunt")
	DropSpear()
	
	Player.ResetJump()
	Player.ResetDash()
	Player.ResetAirAttack()
	Player.process_mode = Node.PROCESS_MODE_DISABLED
	
func ExitState():
	Player.process_mode = Node.PROCESS_MODE_INHERIT
	pass

func Draw():
	pass
	
func Update(delta: float):
	HandleAnimations()

func HandleAnimations():
	Player.HandleFlipH()
	
func DropSpear():
	var spear
	if(Player.playerID == 2):
		spear = PHYSICS_SPEAR_P1.instantiate()
	else:
		spear = PHYSICS_SPEAR_P2.instantiate()
	
	get_tree().current_scene.add_child(spear)
	spear.global_position = Player.global_position
