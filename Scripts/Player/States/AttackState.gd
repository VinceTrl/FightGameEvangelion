extends PlayerState

var attackInAir = false
var inRecover = false
var currentHitbox: Hitbox
@onready var hitbox: Hitbox = $"../../Hitbox"
@onready var hitbox_up: Hitbox = $"../../HitboxUp"
@onready var hitbox_down: Hitbox = $"../../HitboxDown"

#func _ready() -> void:
	#Player.hitbox_down.OnHitboxDetected.connect(HandleHitboxCollision)
	#Player.hitbox_up.OnHitboxDetected.connect(HandleHitboxCollision)
	#Player.attackHitbox.OnHitboxDetected.connect(HandleHitboxCollision)

func EnterState():
	Name = "Attack"
	#Player.hitbox_down.OnHitboxDetected.connect(HandleHitboxCollision)
	#Player.hitbox_up.OnHitboxDetected.connect(HandleHitboxCollision)
	#Player.attackHitbox.OnHitboxDetected.connect(HandleHitboxCollision)
	Player.AdjustAttackDirection()
	var _attackDir = Player.GetAttackDirection()
	Player.velocity = Player.velocity / 3 # ptet enlever ?
	
	var _ratio = Player.attackSpeedForceCurve.sample(Player.currentChargeRatio)
	var _speed = lerp(Player.attackSpeed,Player.attackSpeedMax,_ratio)
	Player.velocity += _attackDir.normalized() * _speed
	
	#SetAttackByForce()
	SetAttackDirection(Player.GetDirection())
	Player.emit_signal("OnPlayerAttack")
	
func ExitState():
	hitbox.InactiveHitBox()
	hitbox_up.InactiveHitBox()
	hitbox_down.InactiveHitBox()
	
	#Player.hitbox_down.OnHitboxDetected.disconnect(HandleHitboxCollision)
	#Player.hitbox_up.OnHitboxDetected.disconnect(HandleHitboxCollision)
	#Player.attackHitbox.OnHitboxDetected.disconnect(HandleHitboxCollision)
	
	
	Player.ResetChargeAttackValue()
	inRecover = false

func Draw():
	pass
	
func Update(delta: float):
	#Player.HandleGravity(Player.attackGravity)
	#Player.HorizontalMovement()
	Player.HandleAttackBuffer()
	HandleHitboxOverlap()
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
	
func HandleHitboxOverlap():
	if(currentHitbox == null): return
	for area in currentHitbox.get_overlapping_areas():
		if area is Hitbox and area != self:
			OnHitboxCollision(area)
	
func OnHitboxCollision(_hitbox:Hitbox):
	if(_hitbox.type != Hitbox.DamageType.Melee): return
	#_hitbox.emit_signal("OnHitboxDetected",currentHitbox)
	print(str(owner.name) + " ATTACK COLLISION WITH :" + str(_hitbox.owner.name))
	Manager.timeManager.freezeFrame(0.001,0.2)
	Manager.gameCamera.camShake.AskCamShake("HitShake")
	Manager.gameManager.vibrationManager.LaunchVibration(Player.playerID-1,"HurtVibration")
	
	Player.velocity = Vector3.ZERO
	Player.lastHitbox = _hitbox
	Player.lastHitLocation = _hitbox.global_position
	Player.ChangeState(States.Knockback)
	pass
	
func SetAttackDirection(direction: Vector3):
	direction = direction.normalized()

	var anim_name := ""

	if abs(direction.x) > abs(direction.y):
		if direction.x > 0 : #attack Right
			anim_name = "Attack"
			currentHitbox = hitbox
		else: #attack Left
			anim_name = "Attack"
			currentHitbox = hitbox
	else:
		if direction.y > 0 : #attack Up
			anim_name = "AttackUp" 
			currentHitbox = hitbox_up
		else: #attack Down
			anim_name = "AttackDown" 
			currentHitbox = hitbox_down

	Player.animator.play(anim_name)
