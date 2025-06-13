extends RigidBody3D

@onready var node_shaker: NodeShaker = $Visual/NodeShaker
@onready var right_wall_checker: RayCast3D = $Raycast/RightWallChecker
@onready var left_wall_checker: RayCast3D = $Raycast/LeftWallChecker
@onready var explosion_location: Marker3D = $ExplosionLocation
@onready var poopMesh : Node3D = $Visual/NodeShaker/SM_Poop_01
@onready var animation_player: AnimationPlayer = $Visual/AnimationPlayer

const EXPLOSION = preload("res://Scenes/Gameplay/explosion.tscn")

@export var healthPoints = 6
@export var gravity : float = 9.8
@export var moveSpeed = 100.0
@export var impulseForce = 10.0
@export var rotateWhileMoving = true
@export var rotation_factor = 2.0


@export_group("SCALE VARIABLES")
@export var scaleMin = 0.25
@export var scaleMax = 2.0
@export var scalingCurve : Curve
@export var maxDistanceForScale = 20.0
@export var exploScaleMultiplier : float = 2.0
@export_group("")



var moveDirection: Vector3 = Vector3(1,0,0)
var canMove = false
var previousPosition
var distanceTravelled : float = 0.000001

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	previousPosition = global_position
	growUpPoop()
	
func movePoop(_delta : float):
	
	#print("vel = " + str(linear_velocity))
	
	updateDistance()
	previousPosition = global_position
	
	var _x = 0.0
	
	#Apply gravity
	#linear_velocity.y -= (gravity * _delta)
	#apply_force(Vector3(0,-gravity,0),Vector3.ZERO)
	
	if(canMove):
		#linear_velocity.x = moveDirection.x * (moveSpeed * _delta)
		_x = moveDirection.x * (moveSpeed * _delta)
		#apply_force(Vector3(_x,0,0),Vector3.ZERO)
		
	apply_force(Vector3(_x,-gravity,0),Vector3.ZERO)
	
	growUpPoop()
	
func updateDistance():
	var _distFromPrevPos = global_position.distance_to(previousPosition)
	distanceTravelled += _distFromPrevPos
	
func growUpPoop():
	
	scale.x = GetTargetScale()
	scale.y = GetTargetScale()
	scale.z = GetTargetScale()
	
func poopRotation(_delta : float):
	if(!rotateWhileMoving): return
	
	var velocity = linear_velocity
	var speed = velocity.length()
	var rotation_amount = speed * rotation_factor
	poopMesh.rotate_y(rotation_amount * _delta)
	
func GetTargetScale() -> float:
	var _distFactor = distanceTravelled / maxDistanceForScale
	var _curveValue = scalingCurve.sample(_distFactor)
	var _scale = lerp(scaleMin,scaleMax,_curveValue)
	return _scale
	
func _physics_process(delta: float) -> void:
	movePoop(delta)
	poopRotation(delta)
	pass
	
func TakeDamage(hitboxSource: Hitbox):
	if(hitboxSource == null): return
	
	print("HIT POOP")
	#canMove = true
	
	
	
	var nextDir = (global_position - hitboxSource.global_position).normalized()
	moveDirection = Vector3(nextDir.x,0,0)
	apply_impulse(nextDir * impulseForce)
	
	if(hitboxSource.type == hitboxSource.DamageType.projectile):
		DestroyPoop()
	
	#Hit effects
	#node_shaker.NodeShake()
	Manager.postProcessEffects.GlitchEffect()
	Manager.timeManager.freezeFrame(0.001,0.1)
	Manager.gameCamera.camShake.AskCamShake("HitShake")
	Manager.gameManager.shitpost_gui.ShowRandomImage()
	animation_player.play("Hurt")
	
	#HurtAnim()
	
func ChangeDirection():
	moveDirection = -moveDirection #bounce direction
	
	
func HurtAnim(_animDuration: float = 0.6,_scaleToAdd: float = 0.25):
	
	var initScale = poopMesh.scale
	var tweenScale = get_tree().create_tween()
	tweenScale.set_ease(Tween.EASE_OUT)
	tweenScale.set_trans(Tween.TRANS_BOUNCE)
	tweenScale.set_parallel(true)
	
	var targetScale = initScale.x + _scaleToAdd
	
	tweenScale.tween_property(poopMesh,"scale:x",targetScale,_animDuration)
	tweenScale.tween_property(poopMesh,"scale:y",targetScale,_animDuration)
	await tweenScale.tween_property(poopMesh,"scale:z",targetScale,_animDuration).finished
	
	poopMesh.scale = initScale
	

func _on_body_entered(body: Node) -> void:
	#print("COL POOP")
	
	#check wall
	if(left_wall_checker.get_collider()):
		moveDirection = Vector3(1,0,0)
		print("GO RIGHT")
	elif(right_wall_checker.get_collider()):
		moveDirection = Vector3(-1,0,0)
		print("GO LEFT")
	
func DestroyPoop():
	var explo = EXPLOSION.instantiate()
	get_tree().get_root().add_child(explo)
	explo.global_position = explosion_location.global_position
	var _exploScale = GetTargetScale() * exploScaleMultiplier
	explo.scale = Vector3(_exploScale,_exploScale,_exploScale)
	queue_free()
