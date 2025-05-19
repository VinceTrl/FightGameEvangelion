class_name Projectile

extends Area3D

@onready var hitbox: Hitbox = $Hitbox
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var sprite: AnimatedSprite3D = $BulletSprite
@onready var sfx: AudioStreamPlayer3D = $Sfx
@onready var raycast: RayCast3D = $RayCast3D

const EXPL_DSGN_ANIME_EXPLOSION_1_01 = preload("res://Assets/Sounds/SFX/EXPLDsgn_Anime Explosion 1_01.wav")
const AUDIO_SCENE = preload("res://Scenes/Audio/audio_scene.tscn")

@export var projectileMinSpeed = 5.0
@export var projectileMaxSpeed = 11.0
@export var maxHit = 6
@export var healthPoints = 8
@export var parrySpeedCurve: Curve
@export var bounceOnWall = true
@export var canBounce = true

var hitByAttack = 0
var facing = 1
var moveDirection: Vector3 = Vector3(1,0,0)
var canMove = false
var chargeRatio = 0.0
var projectileID = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#animator.play("Spawn")
	#global_scale(Vector3(2,2,2))
	
	SetNewID(randi_range(-100000,100000))
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	MoveProjectile(delta)
	var v : Vector2 = Vector2.ONE
	
	
func MoveProjectile(delta:float):
	if (!canMove): return
	global_position += moveDirection * (GetProjectileSpeed() * delta)
	#position.x += facing * (GetProjectileSpeed() * delta)
	

func SetupProjectile (id: int = 0,direction: Vector3 = Vector3.ONE,origin: Vector3 = Vector3.ZERO,_charge: float = 0.0):
	global_position = origin
	chargeRatio = _charge
	#SetNewID(id)
	moveDirection = direction
	var _newFacing = clamp(direction.x,-1,1)
	facing = _newFacing
	#SetSpriteFlipH()
	SetProjectileRotation()
	canMove = true
	PlaySFX()
	
func SetProjectileRotation():
	global_rotation.z = lerp_angle(global_rotation.z,atan2(moveDirection.y,moveDirection.x),1)
	
	
func SetNewID(newID: int):
	projectileID = newID
	hitbox.owner_id = newID
	hurtbox.owner_id = newID
	
func GetProjectileSpeed() -> float:
	var _speedRatio = hitByAttack/maxHit
	var curveRatio = parrySpeedCurve.sample(_speedRatio);
	var _speed = lerp(projectileMinSpeed,projectileMaxSpeed,curveRatio)
	print("SPEED : " + str(_speed))
	print("_speedRatio : " + str(_speedRatio))
	print("hit : " + str(hitByAttack))
	print("maxHit : " + str(maxHit))
	return _speed
	
func TakeDamage(hitboxSource: Hitbox):
	if(hitboxSource == null): return
	
	if(hitboxSource.type == hitboxSource.DamageType.Melee):
		#SetNewID(hitboxSource.owner_id)
		ProjectileBounce()
	else:
		ProjectileImpact()
		
		
func ProjectileBounce(_camShakeToAsk: StringName = "ParryShake"):
	
	healthPoints -= 1
	
	if (healthPoints <= 0): 
		ProjectileImpact()
		return
	
	hitByAttack += 1
	hitByAttack = clampf(hitByAttack,0.0,maxHit)
	#moveDirection = -moveDirection
	
	var normal = raycast.get_collision_normal()
	var newDir = -2*(moveDirection.dot(normal)) * normal + moveDirection
	moveDirection = newDir
	
	SetProjectileRotation()
	Manager.gameCamera.camShake.AskCamShake(_camShakeToAsk)
	PlaySFX()
	
func SetSpriteFlipH():
	sprite.flip_h = (facing < 0)
	
func ProjectileImpact():
	canMove = false
	#animator.play("Impact")
	
	Manager.gameCamera.camShake.AskCamShake("DestroyProjectileShake")
	DestroyProjectile()
	
func DestroyProjectile():
	var audio = AUDIO_SCENE.instantiate()
	#add_child(audio)
	
	get_tree().get_root().add_child(audio)
	audio.StartAudio(EXPL_DSGN_ANIME_EXPLOSION_1_01)
	
	queue_free()

func enter(body: Node2D) -> void:
	if(body == Hitbox): return
	
	ProjectileImpact()
	
func PlaySFX():
	sfx.play()

func _on_hitbox_on_hit() -> void:
	ProjectileImpact()


func _on_body_entered(body: Node3D) -> void:
	if(body == Hitbox): return
	
	if(bounceOnWall): ProjectileBounce()
	else : ProjectileImpact()
