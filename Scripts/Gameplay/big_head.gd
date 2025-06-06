extends Node3D

@export var playerID = 200
@export var healthPoints = 3
@export var hurtTime = 1.0
@export var smoothMoveTargetX: float = 1.0
@export var smoothMoveTargetY: float = 1.0
@export var resetPositionTime: float = 2.5
@export_range(0.0, 1.0, 0.001) var slapChance = 0.25


@onready var hurtbox: Hurtbox = $Hurtbox
@onready var hitbox: Hitbox = $Visual/Hand/Damage/Hitbox
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var nodeShaker: NodeShaker = $Visual/NodeShaker
@onready var debug_values: Label = $CanvasLayer/DEBUG_VALUES
@onready var hurt_sfx: AudioStreamPlayer3D = $Audio/HurtSFX
@onready var eye_l: CSGSphere3D = $Visual/NodeShaker/Head/Eyes/Eye_L
@onready var eye_r: CSGSphere3D = $Visual/NodeShaker/Head/Eyes/Eye_R

var currentHealthPoint = healthPoints
var isTakingDamage = false
var canTakeDamage = true
var isSlaping = false
var initPosition

#look at
var lookTarget : Node3D
var canLookAtTarget = false
var canMovetoTarget = false
var tweenPosToTarget

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	currentHealthPoint = healthPoints
	hurtbox.owner_id = playerID
	hitbox.owner_id = playerID
	initPosition = global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#debug_values.text = "HP : " + str(currentHealthPoint)
	LookAtTarget()
	MoveToTarget()

func TakeDamage(hitboxSource: Hitbox):
	if(!canTakeDamage):return
	
	hitboxSource.DealDamage()
	
	if(hitboxSource.type == hitboxSource.DamageType.Melee): 
		SetLookTarget(hitboxSource.owner)
	
	#print("SOURCE : " + str(hitboxSource.owner))
	Hurt(hitboxSource.damage)
		
func Hurt(_damagePoint: int = 1):
	
	currentHealthPoint -= _damagePoint
	isTakingDamage = true
	canTakeDamage = false
	
	#effects
	nodeShaker.NodeShake()
	hurt_sfx.play()
	Manager.timeManager.freezeFrame()
	Manager.gameCamera.camShake.AskCamShake("HitShake")
	Manager.postProcessEffects.GlitchEffect()
	
	await get_tree().create_timer(hurtTime,true,false,false).timeout
	
	if(currentHealthPoint <= 0):
		var ran = randf_range(0.0,1.0)
		if(ran <= slapChance):
			Slap()
			return
		
	isTakingDamage = false
	canTakeDamage = true
	

func Slap():
	animationPlayer.play("Slap")
	canMovetoTarget = true
	
	await animationPlayer.animation_finished
	
	animationPlayer.play("Idle")
	isTakingDamage = false
	canTakeDamage = true
	canMovetoTarget = false
	ResetPosition()
	#queue_free()
	
func SetLookTarget(_target:Node3D):
	if(_target == null): return
	lookTarget = _target
	canLookAtTarget = true
	
func LookAtTarget():
	if(!canLookAtTarget): return
	if(lookTarget == null): return

	eye_l.look_at(lookTarget.global_position,Vector3.UP,true)
	eye_r.global_rotation = eye_l.global_rotation
	#eye_r.look_at(lookTarget.global_position,Vector3.UP,true)
	
func ResetPosition():
	
	var tweenResetPos = get_tree().create_tween()
	tweenResetPos.set_ease(Tween.EASE_OUT)
	tweenResetPos.set_trans(Tween.TRANS_ELASTIC)
	tweenResetPos.set_parallel(true)
	
	tweenResetPos.tween_property(self,"position:x",initPosition.x,resetPositionTime)
	tweenResetPos.tween_property(self,"position:y",initPosition.y,resetPositionTime)
	
func MoveToTarget():
	if(lookTarget == null): return
	if(!canMovetoTarget): return
	
	var _targetPos: Vector3 = lookTarget.global_position
	#global_position = _newPos
	
	#tween
	if tweenPosToTarget:
		tweenPosToTarget.kill()
		
	tweenPosToTarget = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD).set_parallel(true)
	tweenPosToTarget.tween_property(self,"position:x",_targetPos.x,smoothMoveTargetX)
	tweenPosToTarget.tween_property(self,"position:y",_targetPos.y,smoothMoveTargetY)
	
func StopMoveToTarget():
	if(lookTarget == null): return
	if(!canMovetoTarget): return

	#tween
	if tweenPosToTarget:
		tweenPosToTarget.kill()
		
	canMovetoTarget = false
