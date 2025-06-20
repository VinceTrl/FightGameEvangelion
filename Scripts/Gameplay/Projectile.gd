class_name Projectile

extends RigidBody3D

@onready var hitbox: Hitbox = $Hitbox
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var sprite: AnimatedSprite3D = $BulletSprite
@onready var sfx: AudioStreamPlayer3D = $Sfx
@onready var raycast: RayCast3D = $RayCast3D
@onready var collision_shape: CollisionShape3D = $CollisionShape2D


const EXPL_DSGN_ANIME_EXPLOSION_1_01 = preload("res://Assets/Sounds/SFX/EXPLDsgn_Anime Explosion 1_01.wav")
const AUDIO_SCENE = preload("res://Scenes/Audio/audio_scene.tscn")
const EXPLOSION = preload("res://Scenes/Gameplay/explosion.tscn")
const VFX_PROJECTILE_IMPACT = preload("res://Scenes/VFX/vfx_projectile_impact.tscn")

@export var projectileMinSpeed = 5.0
@export var projectileMaxSpeed = 11.0
@export var projectileAdditiveSpeed: float = 3.0
@export var maxHit = 6
@export var healthPoints = 8
@export var parrySpeedCurve: Curve
@export var bounceOnWall = true
@export var canBounce = true
@export var maxScale = 4
@export var maxChargeDifference = 0.2
@export var explodeWhenDestroyed = true

var hitByAttack = 0
var facing = 1
var moveDirection: Vector3 = Vector3(1,0,0)
var canMove = false
var chargeRatio = 0.0
var additiveRatio = 0.0
var projectileID = 1
var iniScale = 1
var currentHealthPoints = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.body_entered.connect(_on_body_entered)
	SetNewID(randi_range(-100000,100000))
	currentHealthPoints = healthPoints
	
	#print("SCALE : " + str(scale))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print("SCALE : " + str(scale))
	pass

func _physics_process(delta: float) -> void:
	MoveProjectile(delta)
	#HandleHitboxOverlap()
	var v : Vector2 = Vector2.ONE

func MoveProjectile(delta:float):
	if (!canMove): return
	global_position += moveDirection * (GetProjectileSpeed() * delta)

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
	#PlaySFX()
	
func SetProjectileRotation():
	global_rotation.z = lerp_angle(global_rotation.z,atan2(moveDirection.y,moveDirection.x),1)
	
	
func GetProjectileRotation() -> float :
	return lerp_angle(global_rotation.z,atan2(moveDirection.y,moveDirection.x),1)
	
	
func SetNewID(newID: int):
	projectileID = newID
	hitbox.owner_id = newID
	hurtbox.owner_id = newID
	
func GetProjectileSpeed() -> float:
	var _speedRatio = hitByAttack/maxHit
	var curveRatio = parrySpeedCurve.sample(_speedRatio);
	var _speed = lerp(projectileMinSpeed,projectileMaxSpeed,curveRatio) + additiveRatio
	#print("SPEED : " + str(_speed))
	#print("_speedRatio : " + str(_speedRatio))
	#print("hit : " + str(hitByAttack))
	#print("maxHit : " + str(maxHit))
	return _speed
	
func GetChargeDifference(projectileToCompare:Projectile):
	var difference = chargeRatio - projectileToCompare.chargeRatio
	return abs(difference)
	
func TakeDamage(hitboxSource: Hitbox):
	if(hitboxSource == null): return
	
	if(hitboxSource.type == hitboxSource.DamageType.Melee):
		#SetNewID(hitboxSource.owner_id)
		ProjectileBounce("ParryShake",true)
		currentHealthPoints = healthPoints
	elif(hitboxSource.type == hitboxSource.DamageType.projectile):
		OnCollisionWithAnotherProjectile(hitboxSource)
	else:
		ProjectileImpact()
		

func ProjectileBounce(_camShakeToAsk: StringName = "ParryShake",_isDeflected: bool = false):
	
	print("BOUNCE")
	
	currentHealthPoints -= 1
	
	if (currentHealthPoints <= 0):
		ProjectileImpact()
		return
	
	hitByAttack += 1
	hitByAttack = clampf(hitByAttack,0.0,maxHit)
	#moveDirection = -moveDirection
	
	var normal = raycast.get_collision_normal()
	
	if(_isDeflected): normal = -moveDirection
	
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
	
	if(explodeWhenDestroyed):
		var explo = EXPLOSION.instantiate()
		get_tree().get_root().add_child(explo)
		explo.global_position = global_position
	else:
		var audio = AUDIO_SCENE.instantiate()
		get_tree().get_root().add_child(audio)
		audio.StartAudio(EXPL_DSGN_ANIME_EXPLOSION_1_01)
		PlayImpactVFX()
		#pass

	queue_free()

func enter(body: Node2D) -> void:
	if(body == Hitbox): return
	
	ProjectileImpact()
	
func PlaySFX():
	sfx.play()
	PlayImpactVFX()
	

func PlayImpactVFX():
	var impact = VFX_PROJECTILE_IMPACT.instantiate()
	get_tree().current_scene.add_child(impact)
	impact.global_position = global_position
	impact.global_rotation.z = -GetProjectileRotation()
	impact.EmitAllParticles()
	print("VFX INSTANCE CREATED")

func _on_hitbox_on_hit() -> void:
	ProjectileImpact()


func SetProjectileScale(scaleRatio: float):
	
	additiveRatio = lerp(0.0,projectileAdditiveSpeed,scaleRatio)
	print("ADDITIVE : " + str(additiveRatio))
	var targetScale = lerp(iniScale,maxScale,scaleRatio)
	
	sprite.scale = Vector3(targetScale,targetScale,targetScale)
	hitbox.scale = Vector3(targetScale,targetScale,targetScale)
	hurtbox.scale = Vector3(targetScale,targetScale,targetScale)
	raycast.scale = Vector3(targetScale,targetScale,targetScale)
	
	#ScaleShape(collision_shape.shape,targetScale)
	#ScaleShape(hitbox.collision_shape.shape,targetScale)
	#ScaleShape(hurtbox.collision_shape.shape,targetScale)
	#scale = Vector3(targetScale,targetScale,targetScale)
	
	print("SET SCALE TO : " + str(scale))
	
	
func ScaleShape(shape: Shape3D,target_size: float):
	
	if shape is BoxShape3D:
		var x = shape.size.x * target_size
		var y = shape.size.y * target_size
		var z = shape.size.z * target_size
		shape.size = Vector3(x, y, z)

	elif shape is SphereShape3D:
		shape.radius = shape.radius * target_size

	elif shape is CapsuleShape3D:
		shape.radius = target_size
		shape.height = target_size * 2.0
		
		
func HandleHitboxOverlap():
	if(hitbox == null): return
	
	for area in hitbox.get_overlapping_areas():
		if area is Hitbox and area != self:
			OnCollisionWithAnotherProjectile(area)
			
func OnCollisionWithAnotherProjectile(_hitbox:Hitbox):
	if(_hitbox.type != Hitbox.DamageType.projectile): return
	if (_hitbox.owner == owner): return
	if (!_hitbox.isActive):return
	
	var projectile: Projectile
	
	if(_hitbox.owner is Projectile):
		projectile = _hitbox.owner
		var chargeDifference = GetChargeDifference(projectile)
		#if(projectile.chargeRatio == chargeRatio):
		if(chargeDifference <= maxChargeDifference):
			#bounce
			print("BOUNCE ON ANOTHER PROJECTILE")
			ProjectileBounce("ParryShake",true)
			return
		elif(chargeRatio > projectile.chargeRatio):
			print("DESTROY THE OTHER PROJECTILE")
			projectile.ProjectileImpact()

func _on_body_entered(body: Node3D) -> void:
	if(body == Hitbox): return
	
	print("COL")
	if(bounceOnWall): ProjectileBounce()
	else : ProjectileImpact()
