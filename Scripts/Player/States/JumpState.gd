extends PlayerState

@onready var animator: AnimationPlayer = $"../../Animator"


func EnterState():
	Name = "Jump"
	Player.velocity.y = Player.jumpSpeed
	Player.animator.play("JumpStart")
	Player.emit_signal("OnPlayerJump")
	Manager.gameManager.vibrationManager.LaunchVibration(Player.playerID-1,"JumpVibration")
	
func ExitState():
	pass

func Draw():
	pass
	
func Update(delta: float):
	Player.HandleGravity(delta,Player.jumpGravity)
	Player.HorizontalMovement()
	Player.HandleJump()
	Player.HandleDash()
	Player.HandleAttack()
	Player.HandleShoot()
	
	HandleJumpToFall()
	HandleAnimations()

func HandleJumpToFall():
	if (Player.velocity.y <= 0):
		Player.ChangeState(States.JumpPeak)
	
	if (!Player.keyJump):
		Player.velocity.y *= Player.jumpVariableMultiplier
		Player.ChangeState(States.Fall)

func HandleAnimations():
	
	#if(!animator.current_animation == "JumpStart"):
		#animator.play("JumpStart")
		#print("set to JumpStart")
	#Player.animator.play("JumpStart")
	#print(str(animator.current_animation))
	#if(!animator.current_animation == "Jump"):
		#animator.play("Jump")
	Player.HandleFlipH()
	
func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
