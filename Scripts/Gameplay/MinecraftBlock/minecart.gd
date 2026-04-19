extends CharacterBody3D

@export var railDetection:Area3D
@export var movement:MovementComponent
@export var onRailSpeed:float = 3.0
@export var offRailSpeed:float = 2.0

func _ready() -> void:
	railDetection.OnRail.connect(OnRailConnect)
	railDetection.OffRail.connect(OnRailDisconnect)
	
	
func OnRailConnect():
	movement.speed = onRailSpeed
	movement.currentDirection = railDetection.railDirection
	pass
	
func OnRailDisconnect():
	movement.speed = offRailSpeed
	movement.currentDirection = Vector3.ZERO
	pass

func TakeDamage(hitbox:Hitbox):
	#var direction := (global_position - hitbox.global_position).normalized()
	var direction := Vector3.RIGHT
	if(hitbox.global_position.x > global_position.x): 
		direction = Vector3.LEFT
		
	movement.ApplyKnockback(direction)
