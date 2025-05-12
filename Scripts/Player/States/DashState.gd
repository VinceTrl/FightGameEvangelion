extends PlayerState

@export var minDashSpeed = 1
@export var maxDashSpeed = 8
@export var dashDuration = 0.4
@export var dashSpeedCurve: Curve
@export var dashMomentum = 1.2

@onready var collision_shape_hurtbox: CollisionShape3D = $"../../Hurtbox/CollisionShape3D"


func EnterState():
	Name = "Dash"
	Player.dashDirection = Player.GetDashDirection()
	Player.DashTimer.start(dashDuration)
	#Player.velocity = Player.dashDirection.normalized() * Player.dashSpeed
	Player.animator.play("Dash")
	Player.HandleFlipH()
	Manager.gameManager.vibrationManager.LaunchVibration(Player.playerID-1,"DashVibration")
	
func ExitState():
	collision_shape_hurtbox.disabled = false

func Draw():
	pass
	
func Update(delta: float):
	Player.HandleGravity(delta)
	Player.HandleAttackBuffer()
	DashEnd()
	HandleDashSpeed()
	HandleAnimations()
	
	
func HandleDashSpeed():
	if Player.DashTimer.time_left <= 0: return
	Player.velocity = Player.dashDirection.normalized() * GetDashSpeed()
	
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
		Player.velocity *= dashMomentum
		
		if(Player.is_on_floor()): 
			Player.ChangeState(States.Idle)
		else: 
			Player.ChangeState(States.Fall)
