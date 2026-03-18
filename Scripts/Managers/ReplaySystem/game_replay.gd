extends TextureRect


@export var frameInterval:float = 0.025
@export var gameCapture:GameCapture
var textures:Array[Texture2D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	pass # Replace with function body. 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("TakeScreenshot")):
		ReplaySequence()
	pass
	
	
	
func ReplaySequence():
	visible = true
	LoadTextures()
	call_deferred("ReplayTextures")
	#ReplayTextures()
	pass
	
func LoadTextures():
	textures.clear()
	
	for path in gameCapture.screenshotPaths:
		var image := Image.load_from_file(path)
		var texture := ImageTexture.create_from_image(image)
		textures.append(texture)
		
		
func DisplayTexture(index:int):
	texture = textures[index]
	
func ReplayTextures():
	var currentIndex:int = 0
	
	for frame in textures:
		DisplayTexture(currentIndex)
		await get_tree().create_timer(frameInterval).timeout
		currentIndex += 1
		
	texture = null
	visible = false
