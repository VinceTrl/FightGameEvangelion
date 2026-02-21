class_name PyramidHead

extends CharacterBody3D

@export_category("Components")
@export var stateMachine:PyramidHeadStateMachine
@export var movement:MovementComponent
@export var flip:FlipComponent
@export_category("Detections")
@export var hurtboxDetection:HurtboxDetectionCast
@export var obstacleDetectionCast:ShapeCast3D
@export var groundDetection:RayCast3D


var currentState:PyramidHeadState
var previousState:PyramidHeadState

func _ready() -> void:
	InitStateMachine()
	ChangeState(stateMachine.Idle)
	pass
	
	
func InitStateMachine():
	stateMachine.pyramidHead = self
	
	for state in stateMachine.get_children():
		if(state is PyramidHeadState):
			state.StateMachine = stateMachine
			state.Character = self
	
	previousState = stateMachine.Idle
	currentState = stateMachine.Idle
	stateMachine.currentState = currentState
	
	
func ChangeState(nextState:PyramidHeadState):
	if(nextState != null):
		previousState = currentState
		currentState = nextState
		stateMachine.currentState = currentState
		previousState.ExitState()
		currentState.EnterState()
		#print("Pyramid State change from: "+ previousState.Name + " to: " + currentState.Name)
		return

func _process(delta: float) -> void:
	currentState.Update(delta)
	pass
	
	
func ProcessTargetDetection():
	hurtboxDetection.ProcessHurtBoxDetection()
	if(hurtboxDetection.hurtboxInCast):
		print("PH : TARGET DETECTED")
		ChangeState(stateMachine.Attack)
		
#inverse direction if an obstacle is in front of the character
func ProcessObstacleDetection():
	if(obstacleDetectionCast.is_colliding()):
		movement.currentDirection = -movement.currentDirection
	
#inverse direction if no ground is detected in front of the character
func ProcessGroundDetection():
	if(!groundDetection.is_colliding()):
		movement.currentDirection = -movement.currentDirection
		
func ProcessFlip():
	flip.ProcessFlip()
