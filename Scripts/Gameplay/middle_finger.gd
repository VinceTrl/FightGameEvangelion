extends Node3D

@export var lifeTime: float = 10
@export var posSmoothX: float = 0.25
@export var posSmoothY: float = 0.25
@export var followScale: Vector3 = Vector3.ONE
@export var randomScale = true

@onready var audio_hurt: AudioStreamPlayer3D = $AudioHurt

var initScale
var isFollowingCharacter = false
var isHurt = false
var characterToFollow: Node3D


#TWEEN VARIABLES
var TweenPosition
var TweenScale

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initScale = scale


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	FollowCharacter()

func TakeDamage(hitboxSource: Hitbox):
	if(hitboxSource == null): return
	
	if(hitboxSource.owner is Node3D and isHurt == false):
		print("is NODE 3D")
		isHurt = true
		Manager.postProcessEffects.GlitchEffect()
		Manager.timeManager.freezeFrame(0.001,0.1)
		Manager.gameCamera.camShake.AskCamShake("HitShake")
		audio_hurt.play()
		StartFollow(hitboxSource.owner)
		
	
func StartFollow(nodeToFollow: Node3D):
	characterToFollow = nodeToFollow
	
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BOUNCE)  
	tween.set_ease(Tween.EASE_OUT)
	
	var targetScale = followScale
	
	if(randomScale):
		var ranScale = randf_range(initScale.x,followScale.x)
		targetScale = Vector3(ranScale,ranScale,ranScale)
	
	await tween.tween_property(self, "scale", targetScale, 0.8).finished
	
	isFollowingCharacter = true
	
	await get_tree().create_timer(lifeTime,true,false,false).timeout
	Destroy()
	
func FollowCharacter():
	if(!isFollowingCharacter): return
	if(characterToFollow == null): return
	
	#print("update XY")
	#var _middlePos: Vector3 = player1.global_position + player2.global_position/2
	var _targetPos: Vector3 = characterToFollow.global_position
	#global_position = _newPos
	
	#tween
	if TweenPosition:
		TweenPosition.kill()
		
	TweenPosition = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD).set_parallel(true)
	TweenPosition.tween_property(self,"position:x",_targetPos.x,posSmoothX)
	TweenPosition.tween_property(self,"position:y",_targetPos.y,posSmoothY)
	
func Destroy():
	isFollowingCharacter = false
	queue_free()
	
