extends CharacterBody3D

@export var spinNode:Node3D
@export var tiltNode:Node3D
var debugMode:bool = false

@export_group("Spin")
@export var spinOnReady: bool = false
@export var maxSpinSpeed : float = 100.0
@export var spinDecreaseSpeed: float = 5.0
@export var spinIncreaseByDamage: float = 25.0
var currentSpinSpeed : float = 0.0
@export_group("")

@export_group("Tilt")
@export var maxTiltAngle : float = 30.0
@export var tiltDelta: float = 0.25
@export_group("")

@export_group("Movement")
@export var gravity: float = 6.3
@export var movingDir: Vector3 = Vector3.LEFT
@export var accel:float = 0.7
@export var switchVelocityOnDirectionChange: bool = false
@export var maxMovingSpeed:float = 100.0
@export var minMovingSpeed:float = 0.0
@export var speedRelativeToSpin:Curve
var currentMovingSpeed:float
@export_group("")

@export_group("Attack")
@export_range(0.0, 1.0) var hitboxActivationThreshold: float = 0.25
@export_group("")

@export_group("VFXs")
@export var fireParticles: ParticlesHolder
@export var fireRoot:Node3D
@export_custom(PROPERTY_HINT_LINK, "suffix:") var minFireScale: Vector3 = Vector3(0.1,0.1,0.1)
@export_custom(PROPERTY_HINT_LINK, "suffix:") var maxFireScale: Vector3 = Vector3(0.3,0.3,0.3)
@export_group("")

@export_group("Hit effects setting")
@export var shakeCamOnHit = true
@export var shakeCamName = "HitShake"
@export var freezeOnHit = false
@export var glitchOnHit = false
@export_group("")


@onready var debug_label: Label3D = $DebugLabel
@onready var hitbox: Hitbox = $Hitbox
@onready var vfxs: Node3D = $VFXs

@onready var wall_check_r: RayCast3D = $Raycasts/WallCheck_R
@onready var wall_check_l: RayCast3D = $Raycasts/WallCheck_L
@onready var ground_check_r: RayCast3D = $Raycasts/GroundCheck_R
@onready var ground_check_l: RayCast3D = $Raycasts/GroundCheck_L



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	debug_label.visible = debugMode
	SetFireRotation()
	
	if(spinOnReady):
		currentSpinSpeed = maxSpinSpeed
		
	debugMode = Manager.gameDebug.debugBeybalde
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Spin(delta)
	SpinDecrease(delta)
	HandleHitbox()
	Tilt()
	SetParticlesScale()
	Debug()
	
func _physics_process(delta: float) -> void:
	Move(delta)
	HandleGravity(delta,gravity)
	move_and_slide()
	HandleCollision()

func Spin(_delta:float):
	var speed = currentSpinSpeed * _delta
	spinNode.rotate_y(speed)
	
func SpinDecrease(_delta:float):
	currentSpinSpeed -= spinDecreaseSpeed * _delta
	currentSpinSpeed = clampf(currentSpinSpeed,0.0,maxSpinSpeed)
	
func SpinIncrease(_increase:float = spinIncreaseByDamage):
	currentSpinSpeed += _increase
	currentSpinSpeed = clampf(currentSpinSpeed,0.0,maxSpinSpeed)
	
func GetSpinRatio() -> float:
	return currentSpinSpeed / maxSpinSpeed
	
func Tilt():
	var targetAngle = movingDir.normalized() * maxTiltAngle
	var current_angle = tiltNode.rotation.z
	var min_angle = deg_to_rad(0.0)
	var max_angle = -deg_to_rad(targetAngle.x)
	var angle = lerp_angle(min_angle,max_angle,GetMoveSpeedRatio())
	tiltNode.rotation.z = lerp_angle(current_angle,angle,tiltDelta)
	
func Move(_delta:float):
	currentMovingSpeed = GetMoveSpeed()
	var speed = currentMovingSpeed
	var movement = movingDir.normalized() * (speed * _delta)
	velocity.x = move_toward(velocity.x,movement.x,accel)
	
	if(movingDir.x > 0 and !ground_check_r.is_colliding()):
		velocity.x = 0
		ChangeDirection()
	elif(movingDir.x < 0 and !ground_check_l.is_colliding()):
		velocity.x = 0
		ChangeDirection()
		
	
func ChangeDirection():
	movingDir = -movingDir
	SetFireRotation()
	if(switchVelocityOnDirectionChange):
		velocity.x = -velocity.x
	
func GetMoveSpeedRatio() -> float:
	var ratio = GetSpinRatio()
	return speedRelativeToSpin.sample(ratio)
	
func GetMoveSpeed() -> float:
	return lerp(minMovingSpeed,maxMovingSpeed,GetMoveSpeedRatio())
	
func HandleGravity(delta: float, _gravity: float):
	if (!is_on_floor()):
		velocity.y -= _gravity * delta
		#return
		
func SetFireRotation():
	fireRoot.global_rotation.z = lerp_angle(fireRoot.global_rotation.z,atan2(movingDir.y,movingDir.x),1)
	
func SetFireParticles(emitFire:bool):
	if(emitFire):
		fireParticles.EmitParticles()
	else:
		fireParticles.StopParticles()
		
func SetParticlesScale():
	var ratio = GetSpinRatio()
	fireRoot.scale = lerp(minFireScale,maxFireScale,ratio)
	
func HandleCollision():
	if(get_slide_collision_count() > 0):
		if(ground_check_l.is_colliding() and ground_check_r.is_colliding()):
			if(movingDir.x > 0 and wall_check_r.is_colliding()):
				ChangeDirection()
			elif(movingDir.x < 0 and wall_check_l.is_colliding()):
				ChangeDirection()
		
	
func HandleHitbox():
	var ratio = GetSpinRatio()
	if(ratio >= hitboxActivationThreshold and hitbox.isActive == false):
		hitbox.ActiveHitBox()
		SetFireParticles(true)
	elif ratio < hitboxActivationThreshold and hitbox.isActive == true:
		hitbox.InactiveHitBox()
		SetFireParticles(false)
	
func Debug():
	if(!debugMode): return
		
	var debugSpinSpeed = "\n current Spin Speed : " +  str(currentSpinSpeed)
	var debugMovingSpeed = "\n current Moving Speed : " +  str(currentMovingSpeed)
	var debugSpinRatio = "\n current Spin Ratio : " +  str(GetSpinRatio())
	var debugMoveDir = "\n current Move Dir : " +  str(movingDir)
	var debugVelocity = "\n current Velocity : " +  str(velocity)
	
	var debugText = debugSpinSpeed + debugMovingSpeed + debugSpinRatio + debugMoveDir
	debugText += debugVelocity
	
	debug_label.text = debugText

func TakeDamage(hitboxSource: Hitbox):
	velocity = Vector3.ZERO
	SpinIncrease(spinIncreaseByDamage * hitboxSource.damage)
	movingDir = hitboxSource.hitDirection
	SetFireRotation()
	
	#Hit effects
	if(shakeCamOnHit):
		Manager.gameCamera.camShake.AskCamShake(shakeCamName)
		
	if(freezeOnHit):
		Manager.timeManager.freezeFrame(0.001,0.1)
		
	if(glitchOnHit):
		Manager.postProcessEffects.GlitchEffect()
