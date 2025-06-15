extends PlayerState

var attackInAir = false
var inRecover = false
@onready var collision_shape_hitbox: CollisionShape3D = $"../../Hitbox/CollisionShape3D"
@onready var hitbox: Hitbox = $"../../Hitbox"
@onready var hitbox_up: Hitbox = $"../../HitboxUp"
@onready var hitbox_down: Hitbox = $"../../HitboxDown"


func EnterState():
	Name = "Attack"
	
	#Player.velocity.y = 0
	Player.AdjustAttackDirection()
	#Player.HandleFlipH()
	Player.SetSpriteOffset_Attack()
	#Player.HandleAttack()
	
	var _attackDir = Player.GetAttackDirection()
	Player.velocity = Player.velocity / 3
	
	var _ratio = Player.attackSpeedForceCurve.sample(Player.currentChargeRatio)
	var _speed = lerp(Player.attackSpeed,Player.attackSpeedMax,_ratio)
	Player.velocity += _attackDir.normalized() * _speed
	
	#SetAttackByForce()
	SetAttackDirection(Player.GetDirection())
	Player.emit_signal("OnPlayerAttack")
	
func ExitState():
	collision_shape_hitbox.disabled = true
	hitbox.InactiveHitBox()
	hitbox_up.InactiveHitBox()
	hitbox_down.InactiveHitBox()
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
	
func SetAttackDirection(direction: Vector3):
	direction = direction.normalized()

	var anim_name := ""

	if abs(direction.x) > abs(direction.y):
		if direction.x > 0 : #attack Right
			anim_name = "Attack"
		else: #attack Left
			anim_name = "Attack"
	else:
		if direction.y > 0 : #attack Up
			anim_name = "AttackUp" 
		else: #attack Down
			anim_name = "AttackDown" 

	Player.animator.play(anim_name)
