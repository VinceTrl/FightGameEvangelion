class_name PlayerCharacter

extends CharacterBody3D

#region Player variables

#references
@onready var sprite = $Sprite2D
@onready var collider = $Collider
@onready var attackHitbox: Hitbox = $Hitbox
@onready var playerHurtbox: Hurtbox = $Hurtbox
@onready var animator = $Animator
@onready var States = $StateMachine
@onready var JumpBufferTimer = $Timers/JumpBuffer
@onready var CoyoteTimer = $Timers/CoyoteTimer
@onready var DashTimer: Timer = $Timers/DashTimer
@onready var DashBuffer: Timer = $Timers/DashBuffer
@onready var AttackBuffer: Timer = $Timers/AttackBuffer
@onready var shootPoint: Marker3D = $ShootPointRoot/ShootPoint
@onready var shoot_point_root: Node3D = $ShootPointRoot
@onready var sfx: AudioStreamPlayer = $PlayerAudio/Sfx
@onready var Ammo: PlayerAmmo = $PlayerAmmo

const landingSfx = preload("res://Assets/Sounds/SFX/FGHTBf_Anime Land 6_01.wav")

@export var playerID = 1

@export var gameManager: Manager

#player stats variables
@export var healthPoints = 6

#run variables
@export var runSpeed = 3
@export var acceleration = 0.3
@export var deceleration = 0.15

#jump variables
@export var jumpGravity = 5
@export var fallGravity = 10
@export var jumpVelocity = 4
@export var jumpVariableMultiplier = 0.5
@export var jumpBufferTime = 0.15
@export var coyoteTime = 0.25
@export var maxFallVelocity = 10
@export var maxJumps = 2

#Dash
@export var maxDashes = 1
@export var dashSpeed = 6
@export var dashAcceleration = 1.5
@export var dashDuration = 0.4
@export var dashBufferTime = 0.15
@export var dashMomentum = 0.2


#attack variables
@export var attackSpeed = 0.1
@export var attackBufferTime = 0.3
@export var maxAirAttack = 1
@export var attackSpeedMomentum = 0.4
@export var attackSpriteOffset = 20
@export var attackGravity = 10



#movement variables
var isMoving = false
var isFalling = false
var currentHealthPoints = healthPoints
var moveSpeed = runSpeed
var jumpSpeed = jumpVelocity
var moveDirectionX = 0
var jumps = 0
var airAttack = 0

var dashes = 0
var dashDirection: Vector3
var facing = 1

var lastHitbox: Hitbox = null

#inputs variables 
var keyUp = false
var keyDown = false
var keyLeft = false
var keyRight = false
var keyJump = false
var keyJumpPressed = false
var keyAttack = false
var keyAttackJustPressed = false
var keyDash = false
var keyShoot = false
var keyMoveAxisX = 0
var keyMoveAxisY = 0

#State Machine
var currentState = null
var previousState = null

#endregion

#Player signals
signal OnPlayerTakeDamage
signal OnPlayerDeath
signal OnPlayerShoot
signal OnPlayerAttack
signal OnPlayerJump

func _ready():
	
	gameManager = Manager
	Manager.gameManager.RegisterPlayer(self)
	
	#init state machine
	for state in States.get_children():
		state.States = States
		state.Player = self
		previousState = States.Fall
		currentState = States.Fall
		
	#set id
	playerHurtbox.owner_id = playerID
	attackHitbox.owner_id = playerID
	
	if(gameManager == null): push_error("Game Manager is null")

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
	
	keyJump = Input.is_action_pressed("KeyJump_" + str(playerID))
	keyJumpPressed = Input.is_action_just_pressed("KeyJump_" + str(playerID))
	
	keyAttack = Input.is_action_just_released("KeyAttack_" + str(playerID))
	keyAttackJustPressed = Input.is_action_just_pressed("KeyAttack_" + str(playerID))
	
	keyDash = Input.is_action_pressed("KeyDash_" + str(playerID))
	
	keyShoot = Input.is_action_pressed("KeyShoot_" + str(playerID))
	
	keyMoveAxisX = Input.get_axis("KeyLeft_" + str(playerID),"KeyRight_" + str(playerID))
	keyMoveAxisY = Input.get_axis("KeyDown_" + str(playerID),"KeyUp_" + str(playerID))
	
	if keyRight: facing = 1
	if keyLeft: facing = -1

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
		sfx.stream = landingSfx
		sfx.play()
		Manager.gameManager.vibrationManager.LaunchVibration(playerID-1,"LandingVibration")
		
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
	
func HandleDash():
	if(keyDash):
		if(dashes < maxDashes) and (DashTimer.time_left <= 0):
			DashTimer.start(dashBufferTime)
			await DashTimer.timeout
			
			#cancel dash if player is damaged/dead during buffer
			if(currentState == States.Hurt or currentState == States.Death):
				return
				
			dashes += 1
			ChangeState(States.Dash)
		
func GetDashDirection() -> Vector3:
	var _dir = Vector3.ZERO
	if(!keyDown and !keyUp and !keyLeft and !keyRight):
		_dir = Vector3(facing,0,0)
	else:
		_dir = Vector3(keyMoveAxisX,keyMoveAxisY,0)
	return _dir


func HandleAttack():
	if(((keyAttack) or (AttackBuffer.time_left > 0)) and (currentState != States.Attack)):
		
		#air attack
		if (!is_on_floor() and (airAttack < maxAirAttack)):
			airAttack += 1
			ChangeState(States.Attack)
		elif (is_on_floor()):
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
	
func HandleAttackBuffer():
	if (keyAttack):
		AttackBuffer.start(attackBufferTime)
		
		
func HandleShoot():
	if((keyShoot) and (currentState != States.Shoot) and Ammo.currentAmmo > 0):
		Ammo.RemoveAmmo()
		ChangeState(States.Shoot)

func TakeDamage(hitboxSource: Hitbox):
	if (currentState != States.Hurt and currentState != States.Death):
		currentHealthPoints -= hitboxSource.damage
		lastHitbox = hitboxSource
		hitboxSource.DealDamage()
		emit_signal("OnPlayerTakeDamage")
		
		print("SOURCE : " + str(hitboxSource.owner))
		
		if (currentHealthPoints > 0):
			ChangeState(States.Hurt)
		else:
			ChangeState(States.Death)
	
func ApplyProjection(projectionSource : Vector3 = Vector3.ZERO):
	velocity = Vector3.ZERO
	pass
	

func DestroyPlayer():
	queue_free()


func _on_melee_hitbox_on_hit() -> void:
	Manager.gameManager.vibrationManager.LaunchVibration(playerID-1,"HitVibration")
