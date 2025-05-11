extends PlayerState

@onready var projectileScene = preload("res://Scenes/Projectile.tscn")
@onready var recoil_timer: Timer = $"../../Timers/RecoilTimer"

@export var minRecoilSpeed = 0.5
@export var maxRecoilSpeed = 6.0
@export var recoilDuration = 0.1
@export var recoilCurve: Curve
@export var recoilMomentum = 0.1

var inRecoil = false


func EnterState():
	Player.velocity = Vector3.ZERO
	Name = "Shoot"
	#Player.animator.play("Shoot")
	#StartRecoil()
	
func ExitState():
	inRecoil = false

func Draw():
	pass
	
func Update(delta: float):
	#Player.HandleGravity(delta,Player.fallGravity)
	#Player.HorizontalMovement()
	HandleRecoil()
	HandleAnimations()
	
func HandleAnimations():
	Player.HandleFlipH()
	Player.SetSpriteOffset_Attack()
	Player.animator.play("Shoot")
	
func HandleRecoil():
	if(!inRecoil): return
	
	var _timeProgress = recoilDuration - recoil_timer.time_left
	var _recoilRatio = _timeProgress/recoilDuration
	var _curveValue = recoilCurve.sample(_recoilRatio);
	var _recoilSpeed = lerp(minRecoilSpeed,maxRecoilSpeed,_curveValue)
	
	Player.velocity.x = -Player.facing * _recoilSpeed
	
func StartRecoil():
	recoil_timer.start(recoilDuration)
	inRecoil = true
	


func SpawnProjectile():
	var _projectile = projectileScene.instantiate()
	if(_projectile == null) : return
	
	_projectile.global_position = Player.shootPoint.global_position
	add_child(_projectile)
	_projectile.SetupProjectile(Player.playerID,Player.facing,Player.shootPoint.global_position)
	
	StartRecoil()
	Player.emit_signal("OnPlayerShoot")
	Manager.gameCamera.camShake.AskCamShake("ShootShake")
	
func _on_recoil_timer_timeout() -> void:
	Player.velocity *= recoilMomentum
	inRecoil = false
	Player.ChangeState(States.Idle)
