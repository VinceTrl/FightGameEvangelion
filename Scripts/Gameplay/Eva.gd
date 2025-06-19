class_name Eva
extends Node3D

const SLAP_WARNING = preload("res://Scenes/GUI/Slap/slap_warning.tscn")

@export var AnimationPlayerName:String = "AnimationPlayer"
@export var timeToReachTarget:float = 1.5
var animPlayer: AnimationPlayer
var hitbox: Hitbox
var initialPosition


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
		#Engine.time_scale = 0.25
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
	var targetPos = Vector3(global_position.x,slapPosition.y,global_position.z)
	
	var warning = SLAP_WARNING.instantiate()
	get_tree().current_scene.add_child(warning)
	warning.global_position = Vector3(0,slapPosition.y,0)
	
	GoTowardsPosition(targetPos,timeToReachTarget)
	await get_tree().create_timer(timeToReachTarget,true,false,false).timeout
	
	animPlayer.play("Armature|Slap")
	
	#TEMP TIMER
	await get_tree().create_timer(0.7,true,false,false).timeout
	animPlayer.pause()
	
	print("SPAWN TARGETS")
	await get_tree().create_timer(0.7,true,false,false).timeout
	
	#Launch Slap
	hitbox.ActiveHitBox()
	animPlayer.play()
	
	#await animPlayer.animation_finished
	await get_tree().create_timer(1.3,true,false,false).timeout
	
	#Slap finished
	hitbox.InactiveHitBox()
	warning.queue_free()
	Manager.gameCamera.RemoveCameraTarget(self)
	Manager.gameCamera.usePlayerDistanceForTargetZ = true
	
	pass
