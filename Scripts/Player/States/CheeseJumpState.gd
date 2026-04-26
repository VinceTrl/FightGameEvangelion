extends PlayerState

@onready var animator: AnimationPlayer = $"../../Animator"
@onready var ground_location: Marker3D = $"../../GroundLocation"
@onready var sprite_2d: Sprite3D = $"../../Sprite2D"
@onready var kiki_cheese: Node3D = $"../../KikiCheese"


const JUMP_VFX = preload("res://Scenes/VFX/VFX2D/2dvfx_big_impact_smoke.tscn")

func EnterState():
	Name = "Cheese Jump"
	sprite_2d.visible = false
	kiki_cheese.visible = true
	Player.velocity.y = Player.jumpSpeed
	Player.emit_signal("OnPlayerJump")
	Manager.gameManager.vibrationManager.LaunchVibration(Player.playerID-1,"JumpVibration")
	
	var jumpVfx = JUMP_VFX.instantiate()
	jumpVfx.global_position = ground_location.global_position
	get_tree().current_scene.add_child(jumpVfx)

	
	
func ExitState():
	sprite_2d.visible = true
	kiki_cheese.visible = false
	pass

func Draw():
	pass
	
func Update(delta: float):
	Player.HandleGravity(delta,Player.jumpGravity)
	Player.HorizontalMovement()
	Player.HandleJump()
	#Player.HandleDash()
	#Player.HandleAttack()
	#Player.HandleAirAttack()
	#Player.HandleShoot()
	
	HandleJumpToFall()

func HandleJumpToFall():
	if (!Player.keyJump):
		Player.velocity.y *= Player.jumpVariableMultiplier
		Player.ChangeState(States.Cheese)
