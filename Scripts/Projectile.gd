class_name Projectile

extends Area3D

@onready var hitbox: Hitbox = $Hitbox
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var sprite: AnimatedSprite3D = $BulletSprite
@onready var sfx: AudioStreamPlayer3D = $Sfx


@export var projectileMinSpeed = 5.0
@export var projectileMaxSpeed = 11.0
@export var maxHit = 6
@export var parrySpeedCurve: Curve

var hitByAttack = 0
var facing = 1
var canMove = false
var projectileID = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#animator.play("Spawn")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	MoveProjectile(delta)
	
func MoveProjectile(delta:float):
	if (!canMove): return
	position.x += facing * (GetProjectileSpeed() * delta)
	

func SetupProjectile (id: int = 0,startFacing: int = 1,origin: Vector3 = Vector3.ZERO):
	transform.origin = origin
	SetNewID(id)
	facing = startFacing
	SetSpriteFlipH()
	canMove = true
	PlaySFX()
	
	
func SetNewID(newID: int):
	projectileID = newID
	hitbox.owner_id = newID
	hurtbox.owner_id = newID
	
func GetProjectileSpeed() -> float:
	var _speed = projectileMinSpeed
	var _speedRatio = hitByAttack/maxHit
	var curveRatio = parrySpeedCurve.sample(_speedRatio);
	_speed = lerp(projectileMinSpeed,projectileMaxSpeed,curveRatio)
	
	return _speed
	
func TakeDamage(hitboxSource: Hitbox):
	if(hitboxSource == null): return
	
	if(hitboxSource.type == hitboxSource.DamageType.Melee):
		hitByAttack += 1
		hitByAttack = clamp(hitByAttack,0,maxHit)
		facing = -facing
		SetSpriteFlipH()
		SetNewID(hitboxSource.owner_id)
		Manager.gameCamera.camShake.AskCamShake("ParryShake")
		PlaySFX()
	else:
		ProjectileImpact()
	
func SetSpriteFlipH():
	sprite.flip_h = (facing < 0)
	
	
func ProjectileImpact():
	canMove = false
	#animator.play("Impact")
	Manager.gameCamera.camShake.AskCamShake("ImpactShake")
	DestroyProjectile()
	
func DestroyProjectile():
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
	
	ProjectileImpact()
