extends Node3D

@export_category("References")
@export var root:Node3D

@export_category("Settings")
@export var translateOffset:Vector3 = Vector3.UP
@export var translateDuration:float = 1.0
@export var translateCurve:Curve
@export var isOpen:bool = false

var iniPosition:Vector3 = Vector3.ZERO
var timer:SceneTreeTimer = null
var inTranslation:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	iniPosition = root.position
	if(isOpen):
		root.position = iniPosition + translateOffset


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func SwitchGridState():
	if(isOpen):
		CloseGrid()
	else:
		OpenGrid()
	
func OpenGrid():
	isOpen = true
	Translate(iniPosition + translateOffset)
	
func CloseGrid():
	isOpen = false
	Translate(iniPosition)
	
func Translate(targetTranslation:Vector3):
	var currentPos = root.position
	if(currentPos == targetTranslation): return
	
	timer = get_tree().create_timer(translateDuration,true,false,false)
	
	while timer.time_left > 0.0:
		var _timeProgress = translateDuration - timer.time_left 
		var _ratio = _timeProgress/translateDuration
		var _curveValue = translateCurve.sample(_ratio)
		var _position = lerp(currentPos,targetTranslation,_curveValue)
		root.position = _position
		await get_tree().process_frame
		
	root.position = targetTranslation
