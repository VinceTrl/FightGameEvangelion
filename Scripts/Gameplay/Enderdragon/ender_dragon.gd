extends Node3D

@export var fireballDelay:float = 1
@export var targetResetDelay:float = 3
@export var minFireball:int = 1
@export var maxFireball:int = 3
@export_range(0.0,1.0,0.05) var lookWeight:float = 0.1

@export_group("References")
@export var headAnimation:AnimationPlayer
@export var dragonAnimation:AnimationPlayer
@export var materialAnimation:AnimationPlayer
@export var headRotation:RotationToTarget
@export var defaultLookTarget:Node3D
@export var fireballMarker:Marker3D
@export var health:HealthComponent
@export var shaker:NodeShaker

var target:Node3D = null
var targetLastPosition:Vector3
var isLookingAtTarget:bool = true
var hasTarget:bool = false
var isFiring:bool = false
var defaultTargetPosition:Vector3

const DRAGON_FIREBALL = preload("uid://dnissd1g3gmmb")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	defaultTargetPosition = defaultLookTarget.global_position
	#call_deferred("SetTargetRotation")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	ProcessTarget()

func ProcessTarget():
	
	#DebugDraw3D.draw_line(fireballMarker.global_position,defaultLookTarget.global_position)
	
	if(hasTarget):
		if(target):
			targetLastPosition = target.global_position
			defaultLookTarget.global_position = lerp(defaultLookTarget.global_position,targetLastPosition,0.1)
			#DebugDraw3D.draw_sphere(targetLastPosition,0.1)
		else:
			ResetTarget()
	else:
		defaultLookTarget.global_position = lerp(defaultLookTarget.global_position,defaultTargetPosition,0.1)
		#DebugDraw3D.draw_sphere(defaultTargetPosition,0.1)
		
func ProcessLookTarget(targetPos:Vector3):
	if(!isLookingAtTarget):return
	defaultLookTarget.global_position = lerp(defaultLookTarget.global_position,targetPos,lookWeight)
	
func SetTargetRotation():
	headRotation.lookTarget = Manager.gameManager.GetRandomPlayer()
	headRotation.rotateToTarget = true


func TakeDamage(hitbox:Hitbox):
	health.ChangeHealth(-hitbox.damage)
	shaker.NodeShake()
	materialAnimation.play("Hurt")
	
	
	if(hitbox.owner):
		target = hitbox.owner
		#headRotation.lookTarget = target
		hasTarget = true
		FireBall()
		
func FireBall():
	if(isFiring):return
	var ball:int = randi_range(minFireball,maxFireball)
	isFiring = true
	for n in ball:
		await get_tree().create_timer(fireballDelay).timeout
		ThrowFireBall()
		
	await get_tree().create_timer(targetResetDelay).timeout 
	ResetTarget()
	isFiring = false
	
func ThrowFireBall():
	if(!target):return
	isLookingAtTarget = false
	headAnimation.play("Scream")
	var fireball = DRAGON_FIREBALL.instantiate()
	get_tree().current_scene.add_child(fireball)
	fireball.global_position = fireballMarker.global_position
	fireball.StartProjectile(targetLastPosition)
	await headAnimation.animation_finished
	isLookingAtTarget = true
	headAnimation.play("Idle")
	
func ResetTarget():
	headRotation.lookTarget = defaultLookTarget
	target = null
	hasTarget = false
