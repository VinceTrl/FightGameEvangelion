extends Node3D

@export var targetResetDelay:float = 3
@export_range(0.0,1.0,0.001) var lookWeight:float = 0.1
@export var randomAttackTimer:float = 18.0
@export var rideAttackTimer:float = 5.0
@export_range(0.0,1.0,0.01) var randomAttackChance:float = 0.5


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

@export var characterArea:Area3D
@export var beamVFX:GPUParticles3D

@export_group("Audio References")
@export var attackAudioPlayer:AudioStreamPlayer3D
@export var loadBeamAudioPlayer:AudioStreamPlayer3D
@export var blastBeamAudioPlayer:AudioStreamPlayer3D

var target:Node3D = null
var targetLastPosition:Vector3
var isLookingAtTarget:bool = true
var hasTarget:bool = false
var canFire:bool = true
var canTakeDamage:bool = true
var isFiring:bool = false
var defaultTargetPosition:Vector3
var currentLookWeight:float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	defaultTargetPosition = defaultLookTarget.global_position
	currentLookWeight = lookWeight
	beam.visible = false
	warning.visible = false
	characterArea.body_entered.connect(area_body_entered)
	Manager.OnFightFinish.connect(LockAttack)
	RandomAttack()
	#call_deferred("SetTargetRotation")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	ProcessTarget()
	if(isFiring):
		beamVFX.global_position = headRotation.lookTarget.global_position

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
	if(!canTakeDamage):return
	
	health.ChangeHealth(-hitbox.damage)
	
	#effects
	shaker.NodeShake()
	materialAnimation.play("Hurt")
	Manager.timeManager.freezeFrame(0.001,freezeFrameDuration)
	Manager.gameCamera.camShake.AskCamShake(cameraShake)
	Manager.postProcessEffects.GlitchEffect(glitch)
	hurtAudioPlayer.play()
	
	
	
	if(hitbox.owner):
		SetTarget(hitbox.owner)
		ThrowBeam()
		#FireBall()
		

func ResetTarget():
	headRotation.lookTarget = defaultLookTarget
	target = null
	hasTarget = false
	
func ThrowBeam():
	if(!canFire):return
	if(!target):return
	if(isFiring):return
	
	isFiring = true
	
	#warning phase
	warning.visible = true
	loadBeamAudioPlayer.play()
	attackAudioPlayer.play()
	await get_tree().create_timer(warningTime).timeout
	
	
	Manager.gameCamera.camShake.AskCamShake("DragonBeamShake")
	Manager.gameManager.vibrationManager.LaunchVibration(0,"BeamVibration")
	Manager.gameManager.vibrationManager.LaunchVibration(1,"BeamVibration")
	
	#isLookingAtTarget = false
	currentLookWeight = attackLookWeight
	headAnimation.play("Scream")
	blastBeamAudioPlayer.play()
	warning.visible = false
	beam.visible = true
	beamVFX.emitting = true
	beamHitbox.ActiveHitBox()
	await get_tree().create_timer(attackTime).timeout
	
	blastBeamAudioPlayer.stop()
	beamHitbox.InactiveHitBox()
	beam.visible = false
	beamVFX.emitting = false
	#isLookingAtTarget = true
	currentLookWeight = lookWeight
	headAnimation.play("Idle")
	
	isFiring = false
	ResetLookTargetDelay()
	
func LockAttack():
	canFire = false
	canTakeDamage = false
	pass
	
func ResetLookTargetDelay():
	await get_tree().create_timer(targetResetDelay).timeout 
	if(isFiring):return
	ResetTarget()
	
func SetTarget(targetNode:Node3D):
	target = targetNode
	hasTarget = true
	
func RandomAttack():
	await get_tree().create_timer(randomAttackTimer).timeout
	if(!isFiring):
		var rngAttack := randf_range(0.0,1.0)
		if(rngAttack <= randomAttackChance):
			SetTarget(Manager.gameManager.GetRandomPlayer())
			ThrowBeam()
	RandomAttack()
	
func area_body_entered(body:Node3D):
	if(body is PlayerCharacter):
		CheckPlayerOnDragon(body)

func CheckPlayerOnDragon(player:PlayerCharacter):
	await get_tree().create_timer(rideAttackTimer).timeout
	if(isFiring): return
	for body in characterArea.get_overlapping_bodies():
		if(body == player):
			SetTarget(Manager.gameManager.GetPlayerOpponent(player))
			ThrowBeam()
