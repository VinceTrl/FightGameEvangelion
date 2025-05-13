class_name  VibrationManager

extends Node

@onready var VIBRATION = preload("res://Scenes/Managers/vibration.tscn")
@export var vibrations: Array[VibrationParameters] = []

@export var debugVibration = false

var lastVibration

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	DebugVibration()

func DebugVibration() -> void:
	if(!debugVibration): return
	if(Input.is_action_just_pressed("DebugKey")):
		LaunchVibration(0,"DebugVibration")
	
func LaunchVibration(_targetDevice:int,_name:StringName = "DefaultVibration"):
	var _vibration = VIBRATION.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
	add_child(_vibration)
	lastVibration = _vibration
	
	_vibration.StartVibration(_targetDevice,GetVibrationFromName(_name))

func GetVibrationFromName(_vibrationName: StringName) -> VibrationParameters:
	
	for vibration in vibrations: 	
		if(vibration.vibrationName == _vibrationName): return vibration
	
	push_error("No vibration param found")
	return null
