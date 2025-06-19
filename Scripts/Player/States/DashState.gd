extends PlayerState

@export var minDashSpeed: float = 1
@export var maxDashSpeed: float = 8
@export var dashDuration = 0.4
@export var dashSpeedCurve: Curve
@export var dashMomentum = 1.2
@export var ghostInterval = 0.1

var ghost_timer: float = 0.0

@onready var collision_shape_hurtbox: CollisionShape3D = $"../../Hurtbox/CollisionShape3D"
@onready var ground_location: Marker3D = $"../../GroundLocation"
@onready var collider: CollisionShape3D = $"../../Collider"

const VFX_2D_DASH_SMOKE = preload("res://Scenes/VFX/VFX2D/vfx_2d_dash_smoke.tscn")
const GHOST_SPRITE = preload("res://Scenes/VFX/VFX2D/ghost_sprite.tscn")

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
	collision_shape_hurtbox.disabled = true
	#CreateGhostDelay()
	#collider.disabled = true
	
func ExitState():
	collision_shape_hurtbox.disabled = false
	ghost_timer = 0.0
	#collider.disabled = false

func Draw():
	pass
	
func Update(delta: float):
	#Player.HandleGravity(delta)
	Player.HandleAttackBuffer()
	DashEnd()
	HandleDashSpeed()
	HandleAnimations()
	HandleGhost(delta)
	
	
func HandleDashSpeed():
	if Player.DashTimer.time_left <= 0: return
	Player.velocity = Player.dashDirection.normalized() * GetDashSpeed()
	#print("DASH VEL : " + str(Player.dashDirection.normalized() * GetDashSpeed()))
	
func GetDashSpeed() -> float:

	var _timeProgress = dashDuration - Player.DashTimer.time_left
	var _speedRatio = _timeProgress/dashDuration
	var _curveValue = dashSpeedCurve.sample(_speedRatio);
	var _currentDashSpeed = lerp(minDashSpeed,maxDashSpeed,_curveValue)
	
	return _currentDashSpeed
	
func HandleGhost(delta: float):
	ghost_timer += delta
	if ghost_timer >= ghostInterval:
		ghost_timer = 0.0
		CreateGhost()
	
func CreateGhost():
	if(Player.currentState == self):
		var ghost = GHOST_SPRITE.instantiate()
		get_tree().current_scene.add_child(ghost)
		ghost.global_position = Player.global_position
		ghost.SetGhostSprite(Player.sprite)

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
