extends Character

var canMove = true

@export_group("Creeper components") 
@export var health:HealthComponent

@export_group("Creeper Raycast components") 
@export var groundDetection:RayCast3D
@export var obstacleRaycasts:Array[RayCast3D]
@export var targetDetection:ShapeCast3D

var targetDetected:bool = false
var targetLastPosition:Vector3 = Vector3.ZERO

var lastHitbox:Hitbox


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	previousState = stateMachine.Idle
	currentState = stateMachine.Idle
	stateMachine.currentState = currentState
	ChangeState(stateMachine.Idle)

func _process(delta: float) -> void:
	super(delta)
	
func _physics_process(delta: float) -> void:
	super(delta)


func TakeDamage(hitbox:Hitbox):
	if(currentState != stateMachine.Hurt):
		lastHitbox = hitbox
		ChangeState(stateMachine.Hurt)
	
	
#inverse direction if an obstacle is in front of the character
func ProcessObstacleDetection():
	for raycast in obstacleRaycasts:
		if(raycast.is_colliding()):
			movement.currentDirection = -movement.currentDirection
			return
	
#inverse direction if no ground is detected in front of the character
func ProcessGroundDetection():
	if(!groundDetection.is_colliding()):
		movement.currentDirection = -movement.currentDirection
		
func ProcessTargetDetection():
	if(targetDetection.is_colliding()):
		targetDetected = true
		targetLastPosition = targetDetection.get_collision_point(0)
		
		if(currentState != stateMachine.Chase):
			ChangeState(stateMachine.Chase)
			pass
	else:
		targetDetected = false
