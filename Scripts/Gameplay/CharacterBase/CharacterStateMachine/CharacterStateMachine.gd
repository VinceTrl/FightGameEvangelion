class_name CharacterStateMachine

extends Node

@export var debugState:bool = false
@export var drawDebugOffset:Vector3
var currentState:CharacterState = null
var character:Character

#store all differents states


func _process(delta: float) -> void:
	DebugState()

func DebugState():
	if(!character):return
	if(!debugState):return
	var textColor := Color.GREEN 
	DebugDraw3D.draw_text(character.global_position+drawDebugOffset,currentState.stateName,50,textColor)
	
