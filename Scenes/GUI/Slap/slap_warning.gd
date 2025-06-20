extends Node3D


const SLAP_TARGET = preload("res://Scenes/GUI/Slap/slap_target.tscn")

@export_group("Spawning Config")
@export var line_length: float = 10.0
@export var object_count: int = 10
@export var spawn_delay: float = 0.5
@export var startFromRight:bool = true
@export_enum("LeftToRight", "RightToLeft") var spawn_direction: int = 0
@export_group("")

@export_group("Hitbox")
@export var hitboxMoveDuration = 0.3
@export_group("")

var targets: Array = []
var slapHitbox:Hitbox

signal OnAllObjectSpawned

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	slapHitbox = GetHitbox(self)
	slapHitbox.InactiveHitBox()
	#slapHitbox.collision_shape.disabled = true
	SpawnAlongLine()
	pass # Replace with function body.
	
func GetHitbox(node: Node) -> Hitbox:
	for child in node.get_children():
		if child is Hitbox:
			return child
		# Recherche récursive dans les enfants
		var found = GetHitbox(child)
		if found:
			return found
	return null


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func SpawnAlongLine() -> void:
	if object_count <= 0:
		return

	var start_x = -line_length / 2.0
	var spacing = line_length / max(object_count - 1, 1)

	for i in object_count:
		var index = i if spawn_direction == 0 else (object_count - 1 - i)
		var x_pos = start_x + index * spacing
		SpawnWithDelay(Vector3(x_pos, 0,0), i * spawn_delay)
		
	emit_signal("OnAllObjectSpawned")

func SpawnWithDelay(position: Vector3, delay: float) -> void:
	await get_tree().create_timer(delay).timeout
	var instance = SLAP_TARGET.instantiate()
	
	if instance != null:
		instance.position = position 
		add_child(instance)
		targets.append(instance)
		
func SetWarningToAllTargets():
	for target in targets:
		target as AnimatedSprite3D
		target.play("Warning")
		
func Slap():
	print("START SLAAAAP")
	var startingPosX
	var targetPosX
	
	if(spawn_direction == 0):
		startingPosX = -line_length / 2.0
		targetPosX = line_length / 2.0
	else:
		startingPosX = line_length / 2.0
		targetPosX = -line_length / 2.0
		
	var startPos = Vector3(startingPosX,0,0)
	var targetPos = Vector3(targetPosX,0,0)
	print("FROM : " + str(startPos) + " TO :" + str(targetPos))
	slapHitbox.position = startPos
	
	slapHitbox.ActiveHitBox()
	#slapHitbox.collision_shape.disabled = false
	MoveHitbox(targetPos,hitboxMoveDuration)
	await get_tree().create_timer(hitboxMoveDuration,false,false,false).timeout
	slapHitbox.InactiveHitBox()
	#slapHitbox.collision_shape.disabled = true
	print("FINISH SLAAAAP")
	queue_free()
	
func MoveHitbox(targetPosition: Vector3,travelTime: float = 1.0,ease:Tween.EaseType = Tween.EASE_IN_OUT,trans:Tween.TransitionType = Tween.TRANS_LINEAR):
	
	var tween = get_tree().create_tween()
	tween.set_ease(ease)
	tween.set_trans(trans)
	tween.set_parallel(true)
	
	tween.tween_property(slapHitbox,"position:x",targetPosition.x,travelTime)
	tween.tween_property(slapHitbox,"position:y",targetPosition.y,travelTime)
	tween.tween_property(slapHitbox,"position:z",targetPosition.z,travelTime)
