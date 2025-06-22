class_name MovingPlatform
extends Node3D

@onready var collision: CollisionPolygon3D = $eva_aerocarrier/StaticBody3D/CollisionPolygon3D
@onready var camera_target: Node3D = $CameraTarget
@onready var sprites: Node3D = $Sprites

@export var targetNode: Node3D
@export var enterAreraTime: float = 2.0
@export var exitAreraTime: float = 2.0
@export var lifeTimeMin: float = 10.0
@export var lifeTimeMax: float = 15.0
@export var warningTime:float = 3.0
@export var isCameraTarget = false
@export var registerOnManager = true
@export var setPositionOnReady = false
var iniPosition
var inArena = false
var targetPos
var animatedSprites:Array[AnimatedSprite3D]

signal OnPlatformEnter
signal OnPlatformExit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GetAllAnimatedSprite(sprites)
	iniPosition = global_position
	if(registerOnManager):
		Manager.gameManager.platform_manager.RegisterPlatform(self)
		
	if(targetNode == null):
		targetPos = iniPosition
		iniPosition = Vector3(iniPosition.x,iniPosition.y,iniPosition.z-20)
		if(!setPositionOnReady): global_position = iniPosition
	else:
		targetPos = targetNode.global_position
		
	if(setPositionOnReady):
		global_position = targetPos
		inArena = true
		
	ResetAllSprites()
		
func GetAllAnimatedSprite(node: Node):
	for child in node.get_children():
		if(child is AnimatedSprite3D):
			animatedSprites.append(child)
			
func SetAllSpritesInWarning():
	for sprite in animatedSprites:
		sprite.play("Warning")
		
func ResetAllSprites(delay:float = 0.0):
	await get_tree().create_timer(delay,true,false,false).timeout
	for sprite in animatedSprites:
		sprite.play("Empty")

func GoTowardsPosition(targetPosition: Vector3,travelTime: float = 1.0,ease:Tween.EaseType = Tween.EASE_OUT,trans:Tween.TransitionType = Tween.TRANS_ELASTIC):
	
	var tween = get_tree().create_tween()
	tween.set_ease(ease)
	tween.set_trans(trans)
	tween.set_parallel(true)
	
	tween.tween_property(self,"global_position:x",targetPosition.x,travelTime)
	tween.tween_property(self,"global_position:y",targetPosition.y,travelTime)
	tween.tween_property(self,"global_position:z",targetPosition.z,travelTime)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func StartRandomTimedPlatform():
	EnterArena()
	var lifeTime = randf_range(lifeTimeMin,lifeTimeMax)
	await get_tree().create_timer(lifeTime,true,false,false).timeout
	ExitArena()
	
func EnterArena():
	if(inArena): return
	
	inArena = true
	DisableCollision(false)
	GoTowardsPosition(targetPos,enterAreraTime)
	if(isCameraTarget):
		camera_target.AddTarget()
	emit_signal("OnPlatformEnter")
	
func ExitArena():
	if(!inArena): return
	
	SetAllSpritesInWarning()
	await get_tree().create_timer(warningTime,true,false,false).timeout
	
	inArena = false
	GoTowardsPosition(iniPosition,exitAreraTime,Tween.EASE_IN_OUT,Tween.TRANS_BACK)
	DisableCollision(true,exitAreraTime/2)
	ResetAllSprites()
	if(isCameraTarget):
		camera_target.RemoveTarget()
	emit_signal("OnPlatformExit")
	
func DisableCollision(disabled:bool = true ,delay:float = 0.0):
	await get_tree().create_timer(delay,true,false,false).timeout
	collision.disabled = disabled
