extends PlayerState

@onready var projectileScene = preload("res://Scenes/Projectile.tscn")
@onready var recoil_timer: Timer = $"../../Timers/RecoilTimer"

const SHOOT_VFX = preload("res://Scenes/VFX/shoot_vfx.tscn")

@export var minRecoilSpeed = 0.5
@export var maxRecoilSpeed = 6.0
@export var additiveRecoil = 2.0
@export var recoilDuration = 0.15
@export var recoilCurve: Curve
@export var recoilAdditiveCurve: Curve
@export var recoilMomentum = 0.1

var inRecoil = false


func EnterState():
	Player.velocity = Vector3.ZERO
	Name = "Shoot"
	#Player.animator.play("Shoot")
	#Player.player_spear.UpdateSpearRotation(Player.GetDirectionOn8Axis())
	Manager.gameManager.vibrationManager.LaunchVibration(Player.playerID-1,"ShootVibration")
	#StartRecoil()
	
func ExitState():
	Player.player_spear.InactiveSpear()
	Player.ResetShootAttackValue()
	inRecoil = false

func Draw():
	pass
	
func Update(delta: float):
	#Player.HandleGravity(delta,Player.fallGravity)
	#Player.HorizontalMovement()
	#Player.player_spear.UpdateSpearRotation(Player.GetDirectionOn8Axis())
	HandleRecoil()
	HandleAnimations()
	
func HandleAnimations():
	Player.HandleFlipH()
	Player.animator.play("Shoot")
	
func HandleRecoil():
	if(!inRecoil): return
	
	var _timeProgress = recoilDuration - recoil_timer.time_left
	var _recoilRatio = _timeProgress/recoilDuration
	var _curveValue = recoilCurve.sample(_recoilRatio);
	var _recoilSpeed = lerp(minRecoilSpeed,maxRecoilSpeed,_curveValue) + GetAdditiveRecoil()
	
	Player.velocity = -Player.shootDirection * _recoilSpeed
	
	
func GetAdditiveRecoil() -> float:
	var _curveValue = recoilAdditiveCurve.sample(Player.currentShootChargeRatio);
	return lerp(0.0,additiveRecoil,_curveValue)
	
func StartRecoil():
	recoil_timer.start(recoilDuration)
	inRecoil = true
	


func SpawnProjectile():
	Player.Ammo.RemoveAmmo()
	var _projectile = projectileScene.instantiate()
	var _shootFx = SHOOT_VFX.instantiate()
	var projectileSpawnPosition = Player.player_spear.GetShootPosition()
	
	if(_projectile == null) : return
	
	#projectile instance
	get_tree().current_scene.add_child(_projectile)
	_projectile.global_position = projectileSpawnPosition
	
	#vfx instance
	get_tree().current_scene.add_child(_shootFx)
	_shootFx.global_position = projectileSpawnPosition
	
	var _shootDir = Player.shootDirection
	_projectile.SetupProjectile(Player.playerID,_shootDir,projectileSpawnPosition)
	_projectile.SetProjectileScale(Player.currentShootChargeRatio)
	
	Player.ResetChargeAttackValue()
	Player.player_spear.SpearShoot()
	
	StartRecoil()
	Player.emit_signal("OnPlayerShoot")
	Manager.gameCamera.camShake.AskCamShake("ShootShake")
	
func _on_recoil_timer_timeout() -> void:
	Player.velocity *= recoilMomentum
	inRecoil = false
	Player.ChangeState(States.Idle)
