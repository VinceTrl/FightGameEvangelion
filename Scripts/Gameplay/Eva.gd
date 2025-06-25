class_name Eva
extends Node3D

const SLAP_WARNING = preload("res://Scenes/GUI/Slap/slap_warning.tscn")

@export var AnimationPlayerName:String = "AnimationPlayer"
@export var animPlayerChore:AnimationPlayer
@export var timeToReachTarget:float = 0.5
@export var slapStartPauseDuration = 1.0
@export var evaSlapOffset:Vector3
var animPlayer: AnimationPlayer
var hitbox: Hitbox
var initialPosition
var slapWarning

signal OnSlapStart
signal OnSlapPoseReached
signal OnSlapHitStart
signal OnSlapHitEnd
signal OnSlapEnd


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animPlayer = GetAnimationPlayerWithName(self,AnimationPlayerName)
	hitbox = GetHitbox(self)
	if hitbox: print("ANIM PLAYER FOUND")
	hitbox.InactiveHitBox()
	initialPosition = global_position
	Manager.gameManager.RegisterEva(self)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("DebugKey")):
		#Engine.time_scale = 0.5
		StartSlap(Manager.gameManager.players[0].global_position)


func GetAnimationPlayerWithName(node: Node,animationPlayerName: String) -> AnimationPlayer:
	for child in node.get_children():
		if child is AnimationPlayer and child.name == animationPlayerName:
			return child
		# Recherche récursive dans les enfants
		var found = GetAnimationPlayerWithName(child,animationPlayerName)
		if found:
			return found
	return null
	
func GetHitbox(node: Node) -> Hitbox:
	for child in node.get_children():
		if child is Hitbox:
			return child
		# Recherche récursive dans les enfants
		var found = GetHitbox(child)
		if found:
			return found
	return null
	
	
func GoTowardsPosition(targetPosition: Vector3,travelTime: float = 1.0,ease:Tween.EaseType = Tween.EASE_OUT,trans:Tween.TransitionType = Tween.TRANS_QUART):
	
	var tween = get_tree().create_tween()
	tween.set_ease(ease)
	tween.set_trans(trans)
	tween.set_parallel(true)
	
	tween.tween_property(self,"global_position:x",targetPosition.x,travelTime)
	tween.tween_property(self,"global_position:y",targetPosition.y,travelTime)
	tween.tween_property(self,"global_position:z",targetPosition.z,travelTime)
	
func StartSlap(slapPosition:Vector3 = Vector3.ZERO):
	
	Manager.gameCamera.AddCameraTarget(self)
	Manager.gameCamera.usePlayerDistanceForTargetZ = false
	
	#move towards target position
	var targetPos = Vector3(global_position.x,slapPosition.y,global_position.z) + evaSlapOffset
	OnSlapStart.emit()
	animPlayerChore.play("AnimLight_Slap_Intro")
	animPlayer.play("Armature|Slap_Start")
	
	#await animPlayer.animation_finished
	await animPlayerChore.animation_finished
	OnSlapPoseReached.emit()
	await get_tree().create_timer(slapStartPauseDuration,true,false,false).timeout
	
	animPlayerChore.play("AnimLight_Slap_PreHit")
	
	#SPAWN_WARNING
	SpawnWarning(slapPosition)
	
	await animPlayerChore.animation_finished
	
	
	slapWarning.SetWarningToAllTargets()
	
	#movement
	#GoTowardsPosition(targetPos,timeToReachTarget)
	#await get_tree().create_timer(timeToReachTarget,true,false,false).timeout
	
	#Launch Slap
	GoTowardsPosition(targetPos,0.75,Tween.EaseType.EASE_IN_OUT,Tween.TransitionType.TRANS_LINEAR)
	animPlayer.play("Armature|Slap_Hit")
	animPlayerChore.play("AnimLight_Slap_Hit")
	await animPlayer.animation_finished
	DestroyWarning()
	
	#recover
	Manager.gameCamera.RemoveCameraTarget(self)
	Manager.gameCamera.usePlayerDistanceForTargetZ = true
	animPlayer.play("Armature|Slap_Recover")
	await animPlayer.animation_finished
	
	#end recoiver
	OnSlapEnd.emit()
	GoTowardsPosition(initialPosition,timeToReachTarget)
	
func StartSlapHitbox():
	if(slapWarning == null): return
	slapWarning.Slap()
	OnSlapHitStart.emit()
	print("SLAAAAP")
	
func EndSlapHitBox():
	OnSlapHitEnd.emit()
	print("STOP SLAAAAP")
	
func SlapHit():
	print("SLAAAAP FREEZE")
	#Manager.postProcessEffects.ResetGlitch()
	#Manager.timeManager.freezeFrame(0.001,1.25)
	
	
func SpawnWarning(warningPos:Vector3):
	var warning = SLAP_WARNING.instantiate()
	get_tree().current_scene.add_child(warning)
	warning.global_position = Vector3(0,warningPos.y,0)
	slapWarning = warning
	slapWarning.OnHitboxDealDamage.connect(SlapHit)
	
	
func DestroyWarning():
	if(!slapWarning):return
	slapWarning.OnHitboxDealDamage.disconnect(SlapHit)
	slapWarning.queue_free()
	
