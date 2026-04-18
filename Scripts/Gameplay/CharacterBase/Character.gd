class_name Character

extends CharacterBody3D

@export_group("Character Components")
@export var stateMachine:CharacterStateMachine
@export var movement:MovementComponent
@export var flip:FlipComponent
@export var animation:AnimationPlayer

var currentState:CharacterState
var previousState:CharacterState

func _ready() -> void:
	InitStateMachine()
	
func _process(delta: float) -> void:
	currentState.ProcessState(delta)
	
func _physics_process(delta: float) -> void:
	currentState.PhysicsProcessState(delta)

func InitStateMachine():
	stateMachine.character = self
	
	for state in stateMachine.get_children():
		if(state is CharacterState):
			state.stateMachine = stateMachine
			state.character = self
			
func ChangeState(nextState:CharacterState):
	if(nextState != null):
		previousState = currentState
		currentState = nextState
		stateMachine.currentState = currentState
		previousState.ExitState()
		currentState.EnterState()
		print("Character State change from: "+ previousState.stateName + " to: " + currentState.stateName)
		return
