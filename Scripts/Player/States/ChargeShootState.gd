extends PlayerState

@onready var charge_shoot_timer: Timer = $"../../Timers/ChargeShootTimer"


func EnterState():
	Player.velocity = Vector3.ZERO
	Player.player_spear.ActiveSpear()
	Player.player_spear.SpearCharge()
	Name = "ChargeShoot"
	charge_shoot_timer.start(Player.chargeShootTime)
	Player.animator.play("ChargeShoot")
	
	await charge_shoot_timer.timeout
	ChargeReady()
	
func ExitState():
	#Player.player_spear.InactiveSpear()
	pass

func Draw():
	pass
	
func Update(delta: float):
	Player.HandleGravity(delta)
	Player.player_spear.UpdateSpearRotation(Player.GetDirectionOn8Axis())
	HandleChargeShoot()
	HandleAnimations()
	
func HandleAnimations():
	Player.HandleFlipH()
	Player.SetSpriteOffset_Attack()
	Player.animator.play("ChargeShoot")
	
func ChargeReady():
	if(Player.currentState == self):
		print("CHARGE IS FULL AND READY")
		Player.player_spear.SpearChargeReady()
	
	
func HandleChargeShoot():
	#release attack input
	if(Player.keyShoot):
		
		Player.SetChargeShootValue(GetChargeRatio())
		Player.shootDirection = Player.GetDirectionOn8Axis()
		Player.ChangeState(States.Shoot)
		

func GetChargeRatio() -> float :
	
	var _timeProgress = Player.chargeShootTime - charge_shoot_timer.time_left
	var _progressRatio = _timeProgress/Player.chargeShootTime
	
	return _progressRatio
