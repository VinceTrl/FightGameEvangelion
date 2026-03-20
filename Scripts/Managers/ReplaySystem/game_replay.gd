class_name GameReplay

extends TextureRect


@export var frameInterval:float = 0.025
@export var gameCapture:GameCapture
var textures:Array[Texture2D]

signal ReplayStart
signal ReplayFinished

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	pass # Replace with function body. 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("TakeScreenshot")):
		StartReplaySequence()
	pass
	
	
func StartReplaySequence():
	visible = true
	call_deferred("ReplayTextures")
	
func LoadTextures(capture:GameCapture):
	if(!capture):
		push_warning("NO GAME CAPTURE FOUND FOR LOADING TEXTURE FOR REPLAY")
		return
	
	textures.clear()
	for path in capture.screenshotPaths:
		var image := Image.load_from_file(path)
		var texture := ImageTexture.create_from_image(image)
		textures.append(texture)
		
		
func DisplayTexture(index:int):
	texture = textures[index]
	
func ReplayTextures():
	ReplayStart.emit()
	var currentIndex:int = 0
	
	for frame in textures:
		DisplayTexture(currentIndex)
		await get_tree().create_timer(frameInterval).timeout
		currentIndex += 1
		
	ReplayFinished.emit()
	texture = null
	visible = false
	
