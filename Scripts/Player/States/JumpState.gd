extends PlayerState

@onready var animator: AnimationPlayer = $"../../Animator"
@onready var ground_location: Marker3D = $"../../GroundLocation"

const JUMP_VFX = preload("res://Scenes/VFX/VFX2D/2dvfx_big_impact_smoke.tscn")

func EnterState():
	Name = "Jump"
	Player.velocity.y = Player.jumpSpeed
	Player.animator.play("JumpStart")
	Player.emit_signal("OnPlayerJump")
	Manager.gameManager.vibrationManager.LaunchVibration(Player.playerID-1,"JumpVibration")
	
	var jumpVfx = JUMP_VFX.instantiate()
	jumpVfx.global_position = ground_location.global_position
	get_tree().current_scene.add_child(jumpVfx)

	
	
func ExitState():
	pass

func Draw():
	pass
	
func Update(delta: float):
	Player.HandleGravity(delta,Player.jumpGravity)
	Player.HorizontalMovement()
	Player.HandleJump()
	Player.HandleDash()
	#Player.HandleAttack()
	Player.HandleAirAttack()
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
