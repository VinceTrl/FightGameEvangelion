class_name PyramidHeadStateMachine

extends Node


@export var debugState:bool = false
@export var drawDebugOffset:Vector3
var currentState:PyramidHeadState = null

#store all differents states
var pyramidHead:PyramidHead
@onready var Idle: PyramidHeadState = $Idle
@onready var Move: PyramidHeadState = $Move
@onready var Roam: PyramidHeadState = $Roam
@onready var Attack: PyramidHeadState = $Attack
@onready var AttackAnticipation: PyramidHeadState = $AttackAnticipation
@onready var Dance: PyramidHeadState = $Dance
@onready var InfiniteDance: PyramidHeadState = $InfiniteDance

func _process(delta: float) -> void:
	DebugState()
	pass

func DebugState():
	if(!pyramidHead):return
	if(!debugState):return
	var textColor := Color.GREEN 
	DebugDraw3D.draw_text(pyramidHead.global_position+drawDebugOffset,currentState.Name,50,textColor)
	
