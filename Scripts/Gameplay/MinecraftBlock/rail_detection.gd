extends Area3D

var onRail:bool = false
var railForceSet:bool = false

@export var movement:MovementComponent
@export var onRailSpeed:float = 1.0

var railDirection:Vector3 = Vector3.RIGHT

signal OnRail
signal OffRail

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	DebugDraw3D.draw_text(global_position + (Vector3.BACK*0.5),str(onRail),32,Color.RED)
	
func _physics_process(delta: float) -> void:
	UpdateRailStatus()
	ApplyForce(delta)
	
func ApplyForce(delta:float):
	if(onRail):
		#movement.currentDirection = railDirection
		#movement.speed = onRailSpeed
		railForceSet = true
	elif(railForceSet and !onRail):
		#rigidbody.linear_velocity = Vector3.ZERO
		#movement.currentDirection = Vector3.ZERO
		#movement.ResetSpeed()
		railForceSet = false
		
func IsOnRail() -> bool:
	for area in get_overlapping_areas():
		if(area is RailArea):
			area as RailArea
			railDirection = area.railDirection
			return true
	return false
	
func UpdateRailStatus():
	var isOnRail := IsOnRail()
	
	if(isOnRail and !onRail):
		OnRail.emit()
	elif(!isOnRail and onRail):
		OffRail.emit()
		
	onRail = isOnRail
