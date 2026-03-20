extends Label

var debug:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	debug = Manager.gameDebug.debugFPS
	if(!debug):
		visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(debug):
		text = "FPS : " + str(Engine.get_frames_per_second())
