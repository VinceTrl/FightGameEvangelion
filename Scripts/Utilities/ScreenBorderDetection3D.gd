class_name ScreenDetection3D

extends Node

enum ScreenDirection {Up,Down,Left,Right}

@export var margin:int = 100
@export var node:Node3D
@export var label:Label3D
var outOfMargins:bool = false
signal ExitScreenMargin(direction:ScreenDirection)
signal EnterScreenMargin

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(!node): node = owner


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	DetectNodeScreenPosition()
	
	
func DetectNodeScreenPosition():
	var camera = get_viewport().get_camera_3d()
	
	if(camera):
		var screen_pos = camera.unproject_position(node.global_position)
		var viewport_size = get_viewport().size

		if screen_pos.x < margin:
			OnExitMargin(ScreenDirection.Left)
		elif screen_pos.x > viewport_size.x - margin:
			OnExitMargin(ScreenDirection.Right)
		elif screen_pos.y < margin: 
			OnExitMargin(ScreenDirection.Up)
		elif screen_pos.y > viewport_size.y - margin:
			OnExitMargin(ScreenDirection.Down)
		else:
			OnEnterMargin()
			
			
func OnExitMargin(dir:ScreenDirection):
	if(outOfMargins):return
	outOfMargins = true
	DebugLabel("Near : " + str(dir))
	ExitScreenMargin.emit(dir)
	
func OnEnterMargin():
	if(!outOfMargins):return
	outOfMargins = false
	DebugLabel("Inside screen margins")
	EnterScreenMargin.emit()

func DebugLabel(text:String):
	if(!label):return
	label.text = text
