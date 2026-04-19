extends Area3D

var onRail:bool = false
var railForceSet:bool = false

@export var rigidbody:RigidBody3D
@export var onRailSpeed:Vector3 = Vector3.RIGHT

var railDirection:Vector3 = Vector3.RIGHT

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	DebugDraw3D.draw_text(global_position + (Vector3.BACK*0.5),str(onRail),32,Color.RED)
	
func _physics_process(delta: float) -> void:
	onRail = IsOnRail()
	ApplyForce(delta)
	
func ApplyForce(delta:float):
	if(onRail):
		rigidbody.global_position += railDirection * (onRailSpeed * delta)
		railForceSet = true
	elif(railForceSet):
		#rigidbody.linear_velocity = Vector3.ZERO
		railForceSet = false
		
func IsOnRail() -> bool:
	for area in get_overlapping_areas():
		if(area is RailArea):
			area as RailArea
			railDirection = area.railDirection
			return true
	return false
