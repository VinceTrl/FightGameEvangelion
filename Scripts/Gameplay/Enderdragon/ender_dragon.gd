extends Node3D

@export var fireballDelay:float = 1
@export var targetResetDelay:float = 3
@export var minFireball:int = 1
@export var maxFireball:int = 3
@export_range(0.0,1.0,0.001) var lookWeight:float = 0.1

@export_group("Damage Effects")
@export var freezeFrameDuration:float = 0.1
@export var cameraShake:String = "HitShake"
@export var glitch:GlitchParameters = preload("uid://bgvu6c31k2dbe")
@export var hurtAudioPlayer:AudioStreamPlayer3D


@export_group("Beam settings")
@export var warningTime:float = 1.5
@export var attackTime:float = 2.0
@export_range(0.0,1.0,0.001) var attackLookWeight:float = 0.01
@export var warning:Node3D
@export var beam:Node3D
@export var beamHitbox:Hitbox

@export_group("References")
@export var headAnimation:AnimationPlayer
@export var dragonAnimation:AnimationPlayer
@export var materialAnimation:AnimationPlayer
@export var headRotation:RotationToTarget
@export var defaultLookTarget:Node3D
@export var fireballMarker:Marker3D
@export var health:HealthComponent
@export var shaker:NodeShaker
@export var attackAudioPlayer:AudioStreamPlayer3D

var target:Node3D = null
var targetLastPosition:Vector3
var isLookingAtTarget:bool = true
var hasTarget:bool = false
var isFiring:bool = false
var defaultTargetPosition:Vector3
var currentLookWeight:float

const DRAGON_FIREBALL = preload("uid://dnissd1g3gmmb")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	defaultTargetPosition = defaultLookTarget.global_position
	currentLookWeight = lookWeight
	beam.visible = false
	warning.visible = false
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
			ProcessLookTarget(targetLastPosition)
			#defaultLookTarget.global_position = lerp(defaultLookTarget.global_position,targetLastPosition,0.1)
			#DebugDraw3D.draw_sphere(targetLastPosition,0.1)
		else:
			ResetTarget()
	else:
		ProcessLookTarget(defaultTargetPosition)
		#defaultLookTarget.global_position = lerp(defaultLookTarget.global_position,defaultTargetPosition,0.1)
		#DebugDraw3D.draw_sphere(defaultTargetPosition,0.1)
		
func ProcessLookTarget(targetPos:Vector3):
	if(!isLookingAtTarget):return
	defaultLookTarget.global_position = lerp(defaultLookTarget.global_position,targetPos,currentLookWeight)
	
func SetTargetRotation():
	headRotation.lookTarget = Manager.gameManager.GetRandomPlayer()
	headRotation.rotateToTarget = true


func TakeDamage(hitbox:Hitbox):
	health.ChangeHealth(-hitbox.damage)
	
	#effects
	shaker.NodeShake()
	materialAnimation.play("Hurt")
	Manager.timeManager.freezeFrame(0.001,freezeFrameDuration)
	Manager.gameCamera.camShake.AskCamShake(cameraShake)
	Manager.postProcessEffects.GlitchEffect(glitch)
	hurtAudioPlayer.play()
	
	
	
	if(hitbox.owner):
		target = hitbox.owner
		#headRotation.lookTarget = target
		hasTarget = true
		ThrowBeam()
		#FireBall()
		
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
	
func ThrowBeam():
	if(!target):return
	if(isFiring):return
	
	isFiring = true
	
	#warning phase
	warning.visible = true
	await get_tree().create_timer(warningTime).timeout
	
	
	Manager.gameCamera.camShake.AskCamShake("DragonBeamShake")
	Manager.gameManager.vibrationManager.LaunchVibration(0,"BeamVibration")
	Manager.gameManager.vibrationManager.LaunchVibration(1,"BeamVibration")
	attackAudioPlayer.play()
	#isLookingAtTarget = false
	currentLookWeight = attackLookWeight
	headAnimation.play("Scream")
	warning.visible = false
	beam.visible = true
	beamHitbox.ActiveHitBox()
	await get_tree().create_timer(attackTime).timeout
	
	beamHitbox.InactiveHitBox()
	beam.visible = false
	#isLookingAtTarget = true
	currentLookWeight = lookWeight
	headAnimation.play("Idle")
	
	isFiring = false
	ResetLookTargetDelay()
	
func ResetLookTargetDelay():
	await get_tree().create_timer(targetResetDelay).timeout 
	if(isFiring):return
	ResetTarget()
