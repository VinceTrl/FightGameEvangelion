extends PlayerState

@export var minDashSpeed: float = 1
@export var maxDashSpeed: float = 8
@export var dashDuration = 0.4
@export var dashSpeedCurve: Curve
@export var dashMomentum = 1.2

@onready var collision_shape_hurtbox: CollisionShape3D = $"../../Hurtbox/CollisionShape3D"
@onready var ground_location: Marker3D = $"../../GroundLocation"

const VFX_2D_DASH_SMOKE = preload("res://Scenes/VFX/VFX2D/vfx_2d_dash_smoke.tscn")

func EnterState():
	Name = "Dash"
	Player.dashDirection = Player.GetDirection()
	
	#var stormDir: Vector2 = Vector2(Player.dashDirection.x,Player.dashDirection.y)
	#Manager.postProcessEffects.StormEffect()
	
	Player.DashTimer.start(dashDuration)
	#Player.velocity = Player.dashDirection.normalized() * Player.dashSpeed
	Player.animator.play("Dash")
	Player.HandleFlipH()
	Manager.gameManager.vibrationManager.LaunchVibration(Player.playerID-1,"DashVibration")
	
	var vfx = VFX_2D_DASH_SMOKE.instantiate()
	vfx.global_position = ground_location.global_position
	get_tree().current_scene.add_child(vfx)
	
func ExitState():
	collision_shape_hurtbox.disabled = false

func Draw():
	pass
	
func Update(delta: float):
	#Player.HandleGravity(delta)
	Player.HandleAttackBuffer()
	DashEnd()
	HandleDashSpeed()
	HandleAnimations()
	
	
func HandleDashSpeed():
	if Player.DashTimer.time_left <= 0: return
	Player.velocity = Player.dashDirection.normalized() * GetDashSpeed()
	print("DASH VEL : " + str(Player.dashDirection.normalized() * GetDashSpeed()))
	
func GetDashSpeed() -> float:

	var _timeProgress = dashDuration - Player.DashTimer.time_left
	var _speedRatio = _timeProgress/dashDuration
	var _curveValue = dashSpeedCurve.sample(_speedRatio);
	var _currentDashSpeed = lerp(minDashSpeed,maxDashSpeed,_curveValue)
	
	return _currentDashSpeed

func HandleAnimations():
	Player.HandleFlipH()
	
func DashEnd():
	if Player.DashTimer.time_left <= 0:
		Player.DashTimer.stop()
		#Player.velocity *= dashMomentum
		#Player.velocity = Vector3.ZERO
		
		if(Player.is_on_floor()): 
			Player.ChangeState(States.Idle)
		else: 
			Player.ChangeState(States.Fall)
