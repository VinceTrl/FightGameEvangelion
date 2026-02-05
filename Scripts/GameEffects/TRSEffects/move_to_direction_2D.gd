class_name MovementToTarget

extends Node3D


@export var nodeToMove:Node3D
@export var baseNode: Node3D
@export var maxLerpDirection: float = 0.1
@export var moveTarget: Node3D
@export var moveSpeed = 0.05
@export var radius: float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func SetTarget(target:Node3D):
	moveTarget = target
	
func RemoveTarget():
	moveTarget = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	MoveToTarget(delta)

func MoveToTarget(delta):
	if not moveTarget:
		return
		
	var global_pos: Vector2 = Vector2(nodeToMove.global_position.x,nodeToMove.global_position.y)
	var center: Vector2 = Vector2(baseNode.global_position.x,baseNode.global_position.y)
	var targetPos: Vector2 = Vector2(moveTarget.global_position.x,moveTarget.global_position.y)
		
	var from_center = global_pos - center
	#var targetPosition = Vector3(moveTarget.global_position.x,moveTarget.global_position.y,0)
	var direction = (targetPos - global_pos).normalized()
	# Déplace légèrement dans la direction target
	var movement = global_pos + (direction * moveSpeed * delta)
	
	#DebugDraw3D.scoped_config().set_thickness(0.001)
	#DebugDraw3D.draw_line(center,targetPos,Color.RED)
	
	# Si on dépasse le cercle, on ramène sur la limite du cercle
	var v = movement - center
	if v.length() > radius:
		movement = center + v.normalized() * radius
		
	var newPos:Vector3 = Vector3(movement.x,movement.y,nodeToMove.global_position.z)
	nodeToMove.global_position = newPos
	
	DebugDraw3D.scoped_config().set_thickness(0.001)
	DebugDraw3D.draw_line(global_position,newPos,Color.RED)

	
