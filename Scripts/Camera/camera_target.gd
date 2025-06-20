extends Node3D

@export var autoRegister: bool = true
var camera: GameCamera

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GetCamera()
	if(autoRegister): AddTarget()

func GetCamera():
	camera = Manager.gameCamera

func AddTarget():
	if(!camera):return
	camera.AddCameraTarget(self)
	
#connected to tree_exiting()
func RemoveTarget():
	if(!camera):return
	camera.RemoveCameraTarget(self)
