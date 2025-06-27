extends PlayerState

const POOP = preload("res://Scenes/Gameplay/poop.tscn")

func EnterState():
	Name = "Taunt"
	Player.animator.play("Taunt")
	
	SpawnPoop()
	
	if(Player.is_on_floor()): 
		Player.ResetJump()
		Player.ResetDash()
		Player.ResetAirAttack()
	
func ExitState():
	pass

func Draw():
	pass
	
func Update(delta: float):
	Player.HandleFalling()
	Player.HorizontalMovement()
	Player.HandleJump()
	Player.HandleDash()
	Player.HandleAttack()
	Player.HandleShoot()
	
	if (Player.moveDirectionX != 0):
		Player.ChangeState(States.Run)
	
	HandleAnimations()
	
	
func SpawnPoop():
	var spawnPos = Player.shootPoint.global_position
	var poop = POOP.instantiate()
	
	if(poop == null) : return
	
	#projectile instance
	get_tree().current_scene.add_child(poop)
	poop.global_position = spawnPos

func HandleAnimations():
	Player.HandleFlipH()
