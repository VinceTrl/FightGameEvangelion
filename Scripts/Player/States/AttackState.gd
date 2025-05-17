extends PlayerState

var attackInAir = false
var inRecover = false
@onready var collision_shape_hitbox: CollisionShape3D = $"../../Hitbox/CollisionShape3D"


func EnterState():
	Name = "Attack"
	
	#Player.velocity.y = 0
	Player.AdjustAttackDirection()
	Player.HandleFlipH()
	Player.SetSpriteOffset_Attack()
	
	var _attackDir = Player.GetAttackDirection()
	Player.velocity = Player.velocity / 3
	
	var _ratio = Player.attackSpeedForceCurve.sample(Player.currentChargeRatio)
	var _speed = lerp(Player.attackSpeed,Player.attackSpeedMax,_ratio)
	Player.velocity += _attackDir.normalized() * _speed
	
	SetAttackByForce()
	Player.emit_signal("OnPlayerAttack")
	
func ExitState():
	collision_shape_hitbox.disabled = true
	Player.ResetChargeAttackValue()
	inRecover = false

func Draw():
	pass
	
func Update(delta: float):
	#Player.HandleGravity(Player.attackGravity)
	#Player.HorizontalMovement()
	Player.HandleAttackBuffer()
	HandleRecover()
	HandleAnimations()
	
	
func HandleRecover():
	if(!inRecover):return
	
	Player.velocity *= Player.attackSpeedMomentum
	
func SetAttackByForce():
	if(Player.currentAttackForce >= Player.chargedAttackForceThreshold):
		Player.animator.play("ChargedAttack")
		#Engine.time_scale = 0.1
	else :
		Player.animator.play("Attack")
		
		
func StartRecovery():
	inRecover = true
	
func AttackFinished():
	#Player.velocity *= Player.attackSpeedMomentum
	Player.velocity = Vector3.ZERO
	
	if(Player.is_on_floor()): 
		Player.ChangeState(States.Idle)
	else: 
		Player.ChangeState(States.Fall)
	
	#if (Player.is_on_floor()): Player.ChangeState(States.Idle)
	#else: Player.ChangeState(States.Fall)

func HandleAnimations():
	#Player.animator.play("Attack")
	Player.HandleFlipH()
	
