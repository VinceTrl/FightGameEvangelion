extends PlayerState

@onready var ground_location: Marker3D = $"../../GroundLocation"
const JUMP_VFX = preload("res://Scenes/VFX/VFX2D/2dvfx_big_impact_smoke.tscn")

@export var bounceForce:float = 5
@export var bounceForceMultiplier:float = 0.95
var additionnalBounceForce:float = 0
var bounceDirection: Vector3 = Vector3.ZERO


func EnterState():
	Name = "Bounce"
	Player.velocity = Vector3.ZERO
	Player.ResetJump()
	Player.ResetAirAttack()
	Player.ResetDash()
	var bounceForce = bounceForce + additionnalBounceForce
	Player.velocity = bounceDirection * bounceForce
	
	#Effects
	Player.animator.play("JumpStart") #TEMP
	
	Manager.gameManager.vibrationManager.LaunchVibration(Player.playerID-1,"JumpVibration")
	
	var jumpVfx = JUMP_VFX.instantiate()
	jumpVfx.global_position = ground_location.global_position
	get_tree().current_scene.add_child(jumpVfx)
	
func ExitState():
	additionnalBounceForce = 0

func Draw():
	pass
	
func Update(delta: float):
	Player.HandleGravity(delta,Player.jumpGravity)
	Player.HorizontalMovement()
	Player.HandleJump()
	Player.HandleDash()
	Player.HandleAirAttack()
	Player.HandleShoot()
	
	HandleJumpToFall()
	HandleAnimations()

func HandleJumpToFall():
	if (Player.velocity.y <= 0):
		print("Go to fall")
		Player.ChangeState(States.JumpPeak)
		
	Player.velocity *= bounceForceMultiplier
	
	#if (!Player.keyJump):
		#Player.velocity.y *= Player.jumpVariableMultiplier
		#Player.ChangeState(States.Fall)

func HandleAnimations():
	#Player.animator.play("JumpStart")
	Player.HandleFlipH()
	
func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
