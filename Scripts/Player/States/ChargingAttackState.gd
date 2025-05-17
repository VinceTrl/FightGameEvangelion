extends PlayerState

@onready var chargeTimer: Timer = $"../../Timers/ChargeAttackTimer"
@onready var sfx_attack_charge_ready: AudioStreamPlayer3D = $"../../PlayerAudio/Sfx_AttackChargeReady"

@export var chargeRatioThreshold = 0.1

var isCharging = false

func EnterState():
	Name = "Charging Attack"
	
	#go back to idle if cannot attack
	if (!Player.is_on_floor() and (Player.airAttack >= Player.maxAirAttack)):
			Player.ChangeState(States.Idle)
			print("cancel attack in air")
			return
	
	chargeTimer.start(Player.chargeAttackTime)
	
func ExitState():
	chargeTimer.stop()
	isCharging = false

func Draw():
	pass
		
		
func CheckCharge():
	var _timeProgress = Player.chargeAttackTime - chargeTimer.time_left
	var _progressRatio = _timeProgress/Player.chargeAttackTime
	
	if(_progressRatio > chargeRatioThreshold and isCharging == false):
		isCharging = true
		Player.velocity = Vector3.ZERO
		Player.SetSpriteOffset_Attack()
		Player.animator.play("Charge")
	
func Update(delta: float):
	HandleAnimations()
	Player.HandleDash()
	Player.HandleJump()
	HandleChargeAttack()
	
func HandleAnimations():
	CheckCharge()
	Player.HandleFlipH()
	
	
func HandleChargeAttack():
	#release attack input
	if(Player.keyAttack):
		
		print("ATTACK")
		Player.SetChargeAttackValue(GetCharge(),GetChargeRatio())
		Player.ChangeState(States.Attack)
		
		
func GetChargeRatio() -> float :
	
	var _timeProgress = Player.chargeAttackTime - chargeTimer.time_left
	var _progressRatio = _timeProgress/Player.chargeAttackTime
	
	return _progressRatio
	
func GetCharge() -> float :
	
	var _progressRatio = GetChargeRatio()
	var _curveValue = Player.attackForceCurve.sample(_progressRatio);
	var _chargeForce = lerp(Player.minAttackForce,Player.maxAttackForce,_curveValue)
	
	return _chargeForce


func _on_charge_attack_timer_timeout() -> void:
	sfx_attack_charge_ready.play()
