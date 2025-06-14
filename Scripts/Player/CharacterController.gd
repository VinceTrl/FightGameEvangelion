class_name PlayerCharacter

extends CharacterBody3D

#region Player variables

#references
@onready var sprite = $Sprite2D
@onready var collider = $Collider
@onready var attackHitbox: Hitbox = $Hitbox
@onready var playerHurtbox: Hurtbox = $Hurtbox
@onready var animator: AnimationPlayer = $Animator
@onready var States = $StateMachine
@onready var debug_values: Label = $CanvasLayer/DEBUG_VALUES
@onready var JumpBufferTimer = $Timers/JumpBuffer
@onready var CoyoteTimer = $Timers/CoyoteTimer
@onready var DashTimer: Timer = $Timers/DashTimer
@onready var DashBuffer: Timer = $Timers/DashBuffer
@onready var AttackBuffer: Timer = $Timers/AttackBuffer
@onready var shootPoint: Marker3D = $ShootPointRoot/ShootPoint
@onready var shoot_point_root: Node3D = $ShootPointRoot
@onready var sfx: AudioStreamPlayer = $PlayerAudio/Sfx
@onready var Ammo: PlayerAmmo = $PlayerAmmo
@onready var nodeShaker: NodeShaker = $NodeShaker
@onready var raycastHolder: Node3D = $RaycastHolder
@onready var backPlayerDetection: RayCast3D = $RaycastHolder/BackPlayerDetection
@onready var ground_location: Marker3D = $GroundLocation

const landingSfx = preload("res://Assets/Sounds/SFX/FGHTBf_Anime Land 6_01.wav")
const SD_GROUND_HIT = preload("res://Assets/Sounds/SFX/DoudouSFX/SD_GroundHit.wav")
const VFX_2D_LANDING = preload("res://Scenes/VFX/VFX2D/vfx_2d_landing.tscn")

@export var playerID = 1

var gameManager: Manager

#player stats variables
@export var healthPoints = 6
@export var startFacingRight = true
var isDead: bool = false

#run variables
@export_group("Movement")
@export var runSpeed = 3.0
@export var acceleration = 0.3
@export var deceleration = 0.15
@export_group("")

#jump variables
@export_group("Jump")
@export var jumpGravity = 6.0
@export var fallGravity = 10.0
@export var jumpVelocity = 3.6
@export var jumpVariableMultiplier = 0.75
@export var jumpBufferTime = 0.15
@export var coyoteTime = 0.25
@export var maxFallVelocity = 10.0
@export var maxJumps = 2
@export var fallGravityMultiplier = 1.5
@export_group("")

#Dash
@export_group("Dash")
@export var maxDashes = 1
@export var dashSpeed = 6
@export var dashAcceleration = 1.5
@export var dashDuration = 0.4
@export var dashBufferTime = 0.15
@export var dashMomentum = 0.2
@export_group("")

#attack variables
@export_group("Attack")
@export var attackSpeed = 0.1
@export var attackSpeedMax = 6.0
@export var attackSpeedMomentum = 0.4
@export var attackSpeedForceCurve: Curve

@export var maxAirAttack = 1
@export var attackGravity = 10
@export var attackBufferTime = 0.3

@export var chargeAttackTime: float = 2.0
@export var chargedAttackForceThreshold = 1.5
@export var minAttackForce = 1.0
@export var maxAttackForce = 3.0
@export var attackForceCurve: Curve

@export var attackSpriteOffset = 20
@export_group("")

#attack variables
@export_group("Shoot")
@export var chargeShootTime: float = 1.0
@export var chargedShoothreshold = 0.8
@export_group("")

@export var debugMode = false

#movement variables
var isMoving = false
var isFalling = false
var currentHealthPoints = healthPoints
var moveSpeed = runSpeed
var jumpSpeed = jumpVelocity
var moveDirectionX = 0
var jumps = 0
var airAttack = 0

var currentAttackForce = 0.0
var currentChargeRatio = 0.0

var currentShootChargeForce = 0.0
var currentShootChargeRatio = 0.0

var dashes = 0
var dashDirection: Vector3
var facing = 1

var lastHitbox: Hitbox = null
var lastHitLocation

#inputs variables 
var keyUp = false
var keyDown = false
var keyLeft = false
var keyRight = false

var keyJump = false
var keyJumpPressed = false

var keyAttack = false
var keyAttackHold = false
var keyAttackJustPressed = false

var keyDash = false

var keyShoot = false
var keyShootHold = false
var keyShootPressed = false

var keyMoveAxisX = 0
var keyMoveAxisY = 0
var key8Direction

#State Machine
var currentState: PlayerState = null
var previousState: PlayerState = null

#endregion

#Player signals
signal OnPlayerTakeDamage
signal OnPlayerDeath
signal OnPlayerShoot
signal OnPlayerAttack
signal OnPlayerJump
signal OnPlayerLifeChanged

func _ready():
	
	gameManager = Manager
	Manager.gameManager.RegisterPlayer(self)
	
	#init state machine
	for state in States.get_children():
		state.States = States
		state.Player = self
		previousState = States.Locked
		currentState = States.Locked
		
	#set id
	playerHurtbox.owner_id = playerID
	attackHitbox.owner_id = playerID
	
	if(startFacingRight): facing = 1
	else: facing = -1
	
	if(gameManager == null): push_error("Game Manager is null")
	
	currentHealthPoints = healthPoints
	moveSpeed = runSpeed
	jumpSpeed = jumpVelocity

func _draw():
	currentState.Draw()

func _physics_process(delta: float) -> void:
	GetInputStates()
	
	
	#Update state
	currentState.Update(delta)
	
	#movements
	HandleMaxVelocity()

	
	#apply movements
	move_and_slide()
	
	DebugPlayer()

func ChangeState(nextState):
	if(nextState != null):
		previousState = currentState
		currentState = nextState
		previousState.ExitState()
		currentState.EnterState()
		#print("State change from: "+ previousState.Name + " to: " + currentState.Name)
		return
		


func GetInputStates():
	keyUp = Input.is_action_pressed("KeyUp_" + str(playerID))
	keyDown = Input.is_action_pressed("KeyDown_" + str(playerID))
	keyRight = Input.is_action_pressed("KeyRight_" + str(playerID))
	keyLeft = Input.is_action_pressed("KeyLeft_" + str(playerID))
	
	var _dirX = int(Input.is_action_pressed("KeyRight_" + str(playerID))) - int(Input.is_action_pressed("KeyLeft_" + str(playerID)))
	var _dirY = int(Input.is_action_pressed("KeyUp_" + str(playerID))) - int(Input.is_action_pressed("KeyDown_" + str(playerID)))
	key8Direction = Vector2(_dirX,_dirY)
	
	keyJump = Input.is_action_pressed("KeyJump_" + str(playerID))
	keyJumpPressed = Input.is_action_just_pressed("KeyJump_" + str(playerID))
	
	keyAttack = Input.is_action_just_released("KeyAttack_" + str(playerID))
	keyAttackHold = Input.is_action_pressed("KeyAttack_" + str(playerID))
	keyAttackJustPressed = Input.is_action_just_pressed("KeyAttack_" + str(playerID))
	
	keyDash = Input.is_action_pressed("KeyDash_" + str(playerID))
	
	keyShoot = Input.is_action_just_released("KeyShoot_" + str(playerID))
	keyShootHold = Input.is_action_pressed("KeyShoot_" + str(playerID))
	keyShootPressed = Input.is_action_just_pressed("KeyShoot_" + str(playerID))
	
	keyMoveAxisX = Input.get_axis("KeyLeft_" + str(playerID),"KeyRight_" + str(playerID))
	keyMoveAxisY = Input.get_axis("KeyDown_" + str(playerID),"KeyUp_" + str(playerID))
	
	if keyRight: facing = 1
	if keyLeft: facing = -1
	
func DebugPlayer():
	if(debugMode): 
		var debug_currentState = "\n /player cur State : " + str(currentState.name)
		var debug_previousState = "\n /player prev State : " + str(previousState.name)
		var debug_velocity = "\n /player velocity: " + str(velocity)
		var debug_attackForce = "\n /air attack : " + str(airAttack)
		
		debug_values.text = "DEBUG : "  + debug_currentState + debug_previousState + debug_velocity + debug_attackForce
		
		
func HandleGravity(delta: float, gravity: float = jumpGravity):
	if (!is_on_floor()):
		velocity.y -= gravity * delta
		#return

func HandleFalling():
	if (!is_on_floor()):
		ChangeState(States.Fall)
		

func HandleMaxVelocity():
	if (velocity.y > maxFallVelocity): velocity.y = maxFallVelocity

func HandleLanding():
	if (is_on_floor()):
		ChangeState(States.Idle)
		ResetJump()
		ResetDash()
		ResetAirAttack()
		sfx.stream = SD_GROUND_HIT
		sfx.play()
		Manager.gameManager.vibrationManager.LaunchVibration(playerID-1,"LandingVibration")
		var vfx = VFX_2D_LANDING.instantiate()
		vfx.global_position = ground_location.global_position
		get_tree().current_scene.add_child(vfx)
			
func ResetDash():
	dashes = 0
	
func ResetAirAttack():
	airAttack = 0
	
func ResetJump():
	jumps = 0

func HorizontalMovement(acceleration : float = acceleration, deceleration : float = deceleration):
	moveDirectionX = keyMoveAxisX
	if moveDirectionX != 0:
		velocity.x = move_toward(velocity.x,moveDirectionX * moveSpeed,acceleration)
	else:
		velocity.x = move_toward(velocity.x,moveDirectionX * moveSpeed,deceleration)
	
	if velocity.x != 0:
		isMoving = true
	else:
		isMoving = false

func HandleJump():
	if((keyJumpPressed or (JumpBufferTimer.time_left > 0)) and (jumps < maxJumps)):
		jumps += 1
		JumpBufferTimer.stop()
		ChangeState(States.Jump)
		
		
func HandleJumpBuffer():
	if (keyJumpPressed):
		JumpBufferTimer.start(jumpBufferTime)

func HandleFlipH():
	sprite.flip_h = (facing < 0)
	
	#hitbox flip
	attackHitbox.scale.x = facing
	shoot_point_root.scale.x = facing
	raycastHolder.scale.x = facing
	
func HandleDash():
	if(keyDash):
		if(dashes < maxDashes) and (DashTimer.time_left <= 0):
			#DashTimer.start(dashBufferTime)
			#await DashTimer.timeout
			
			#cancel dash if player is damaged/dead during buffer
			if(currentState == States.Hurt or currentState == States.Death):
				return
				
			dashes += 1
			ChangeState(States.Dash)
		
func GetDirection() -> Vector3:
	var _dir = Vector3.ZERO
	if(!keyDown and !keyUp and !keyLeft and !keyRight):
		_dir = Vector3(facing,0,0)
	else:
		_dir = Vector3(keyMoveAxisX,keyMoveAxisY,0)
	return _dir
	
func GetDirectionOn8Axis() -> Vector3:
	var _dir = Vector3.ZERO
	if(!keyDown and !keyUp and !keyLeft and !keyRight):
		_dir = Vector3(facing,0,0)
	else:
		_dir = Vector3(key8Direction.x,key8Direction.y,0)
	return _dir.normalized()
	
#func HandleAttack():
	#if(((keyAttack) or (AttackBuffer.time_left > 0)) and (currentState != States.Attack)):
		#
		##in air no charged attack
		#if (!is_on_floor() and (airAttack < maxAirAttack)):
			#airAttack += 1
			#ChangeState(States.Attack)
		#elif (is_on_floor()):
			#ChangeState(States.ChargingAttack)


func HandleAttack():
	if(((keyAttackJustPressed)) and (currentState != States.Attack)):
		#ChangeState(States.ChargingAttack)
		ChangeState(States.Attack)
		return
		
	if(((AttackBuffer.time_left > 0)) and (currentState != States.Attack)):
		ChangeState(States.Attack)
		return
		
		
		
func HandleAirAttack():
	if(((keyAttack) or (AttackBuffer.time_left > 0)) and (currentState != States.Attack)):
		
		if (!is_on_floor() and (airAttack < maxAirAttack)):
			airAttack += 1
			ChangeState(States.Attack)
		
		
func SetSpriteOffset_Attack():
	if (sprite.flip_h == true): #facing left
		sprite.offset.x = -attackSpriteOffset
	else: #facing right
		sprite.offset.x = attackSpriteOffset
		
func GetAttackDirection() -> Vector3:
	var _dir = Vector3.ZERO
	if(!keyLeft and !keyRight):
		_dir = Vector3(facing,0,0)
	else:
		_dir = Vector3(keyMoveAxisX,0,0)
	return _dir
	
func AdjustAttackDirection():
	if backPlayerDetection.is_colliding():
		var _collision = backPlayerDetection.get_collider()
		if(_collision is PlayerCharacter):
			_collision as PlayerCharacter
			if(_collision.playerID == playerID): return
			ChangePlayerDirection(-facing)
	
func ChangePlayerDirection(_facingDir: int):
	if(facing == 0): return
	_facingDir = clamp(_facingDir,-1,1)
	facing = _facingDir
	
func HandleAttackBuffer():
	if (keyAttackJustPressed):
		AttackBuffer.start(attackBufferTime)
		
		
func SetChargeAttackValue(_charge:float,_chargeRatio:float):
	currentAttackForce = _charge
	currentChargeRatio = _chargeRatio
	
func ResetChargeAttackValue():
	currentAttackForce = 0.0
	currentChargeRatio = 0.0
	
func SetChargeShootValue(_chargeRatio:float):
	currentShootChargeRatio = _chargeRatio
	
func ResetShootAttackValue():
	currentShootChargeRatio = 0.0
		
func HandleShoot():
	if((keyShootPressed) and (currentState != States.Shoot)):
		if(Ammo.currentAmmo > 0):
			ChangeState(States.ChargeShoot)
			
func AddHealth(_points: int):
	currentHealthPoints += _points
	currentHealthPoints = clampi(currentHealthPoints,0,healthPoints)
	emit_signal("OnPlayerLifeChanged")
	
func RemoveHealth(_points: int):
	currentHealthPoints -= _points
	currentHealthPoints = clampi(currentHealthPoints,0,healthPoints)
	emit_signal("OnPlayerLifeChanged")

func TakeDamage(hitboxSource: Hitbox):
	if (currentState != States.Hurt and currentState != States.Death and currentState != States.Knockback):
		#currentHealthPoints -= hitboxSource.damage
		RemoveHealth(hitboxSource.damage)
		lastHitbox = hitboxSource
		lastHitLocation = hitboxSource.global_position
		hitboxSource.DealDamage()
		emit_signal("OnPlayerTakeDamage")
		
		print("SOURCE : " + str(hitboxSource.owner))
		
		
		if (currentHealthPoints > 0):
			ChangeState(States.Hurt)
		else:
			isDead = true
			ChangeState(States.Death)
	
func ApplyProjection(projectionSource : Vector3 = Vector3.ZERO):
	velocity = Vector3.ZERO
	pass
	

func DestroyPlayer():
	queue_free()
	
func ChangeSpriteColor():
	pass

func _on_melee_hitbox_on_hit() -> void:
	Manager.gameManager.vibrationManager.LaunchVibration(playerID-1,"HitVibration")


func _on_hurtbox_area_entered(area: Area3D) -> void:
	pass # Replace with function body.
