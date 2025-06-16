class_name MovingPlatform
extends Node3D

@export var targetNode: Node3D
@export var enterAreraTime: float = 2.0
@export var exitAreraTime: float = 2.0
@export var lifeTimeMin: float = 10
@export var lifeTimeMax: float = 15
var iniPosition

signal OnPlatformEnter
signal OnPlatformExit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	iniPosition = global_position
	Manager.gameManager.platform_manager.RegisterPlatform(self)
	#await get_tree().create_timer(10,true,false,false).timeout
	#EnterArena()

func GoTowardsPosition(targetPosition: Vector3,travelTime: float = 1.0):
	
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.set_parallel(true)
	
	tween.tween_property(self,"global_position:x",targetPosition.x,travelTime)
	tween.tween_property(self,"global_position:y",targetPosition.y,travelTime)
	tween.tween_property(self,"global_position:z",targetPosition.z,travelTime)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func EnterArena():
	GoTowardsPosition(targetNode.global_position,enterAreraTime)
	emit_signal("OnPlatformEnter")
	var lifeTime = randf_range(lifeTimeMin,lifeTimeMax)
	await get_tree().create_timer(lifeTime,true,false,false).timeout
	ExitArena()
	
func ExitArena():
	GoTowardsPosition(iniPosition,exitAreraTime)
	emit_signal("OnPlatformExit")
