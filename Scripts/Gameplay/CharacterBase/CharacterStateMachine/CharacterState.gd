class_name CharacterState
extends Node

var stateMachine:CharacterStateMachine = null
var character:Character = null
var stateName: String = "NULL STATE"

func EnterState():
	pass
	
func ExitState():
	pass
	
func ProcessState(delta: float):
	pass
	
func PhysicsProcessState(delta: float):
	pass
