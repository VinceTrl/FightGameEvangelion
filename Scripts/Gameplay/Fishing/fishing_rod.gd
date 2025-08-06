class_name FishingRod

extends Node3D

@export var debugMode = false

@onready var fishing_states: Node = $FishingStates
@onready var fishing_rod_animation: AnimationPlayer = $FishingRod/FishingRodAnimation
@onready var debug_label: Label3D = $DebugLabel
@onready var hook: FishHook = $Hook

var previousState 
var currentState
var lastPlayer: PlayerCharacter

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	hook.fishingRodOwner = self
	
	#init state machine
	for state in fishing_states.get_children():
		state.StateMachine = fishing_states
		state.FishingRodOwner = self
		previousState = fishing_states.Idle
		currentState = fishing_states.Idle
		
	ChangeState(fishing_states.Idle)


func ChangeState(nextState):
	if(nextState != null):
		previousState = currentState
		currentState = nextState
		previousState.ExitState()
		currentState.EnterState()
		#print("State change from: "+ previousState.Name + " to: " + currentState.Name)
		return

func TakeDamage(hitboxSource: Hitbox):
	if(hitboxSource == null): return
	
	if(currentState == fishing_states.Idle):
		ChangeState(fishing_states.Throw)
	elif(currentState == fishing_states.Fish):
		ChangeState(fishing_states.Pull)
		
	if(hitboxSource.owner is PlayerCharacter):
		lastPlayer = hitboxSource.owner
	
	#Hit effects
	Manager.gameCamera.camShake.AskCamShake("HitShake")
	Manager.timeManager.freezeFrame(0.001,0.1)
	#Manager.postProcessEffects.GlitchEffect()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	DebugText()
	pass
	

func DebugText():
	if(!debugMode): return
	
	var debug_currentState = "\n /current State : " + str(currentState.name)
	var debug_previousState = "\n /previous State : " + str(previousState.name)
	var debugText = debug_currentState + debug_previousState
	debug_label.visible = true
	debug_label.text = debugText
