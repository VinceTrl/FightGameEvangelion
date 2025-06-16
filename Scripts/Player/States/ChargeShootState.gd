extends PlayerState

@onready var charge_shoot_timer: Timer = $"../../Timers/ChargeShootTimer"


func EnterState():
	Player.velocity = Vector3.ZERO
	Name = "ChargeShoot"
	charge_shoot_timer.start(Player.chargeShootTime)
	
	#Player.animator.play("StartChargeShoot")
	#await Player.animator.animation_finished
	Player.animator.play("ChargeShoot")
	
func ExitState():
	pass

func Draw():
	pass
	
func Update(delta: float):
	Player.HandleGravity(delta)
	HandleChargeShoot()
	HandleAnimations()
	
func HandleAnimations():
	Player.HandleFlipH()
	Player.SetSpriteOffset_Attack()
	Player.animator.play("ChargeShoot")
	
	
func HandleChargeShoot():
	#release attack input
	if(Player.keyShoot):
		
		Player.SetChargeShootValue(GetChargeRatio())
		Player.ChangeState(States.Shoot)
		

func GetChargeRatio() -> float :
	
	var _timeProgress = Player.chargeShootTime - charge_shoot_timer.time_left
	var _progressRatio = _timeProgress/Player.chargeShootTime
	
	return _progressRatio
