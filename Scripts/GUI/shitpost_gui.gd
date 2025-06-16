class_name ShitpostGUI

extends Control

@export var textureScale: Vector2 = Vector2.ONE
@export var textures: Array[CompressedTexture2D] = []
@export var imageSize: float = 0.5
@export var debugMode = false

@onready var texture_holder_root: Control = $CanvasLayer/TextureHolderRoot
var textureHolders: Array[TextureRect] = []
var currentIndex

signal OnRandomImageSetVisible
signal OnRandomImageSetInvisible

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GetAllTextureHolders()
	call_deferred("ResetTexture")
	#ResetTexture()
	#RandomTextureLoop()
	#OnRandomImageSetInvisible.connect(RandomTextureLoop)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Debug()
	
func Debug():
	if(!debugMode): return
	
	if(Input.is_action_just_pressed("DebugKey")):
		ShowRandomImage()

func GetAllTextureHolders():
	for child in get_children():
		if(child is TextureRect): textureHolders.append(child)
	
func ResetTexture():
	for texture in textureHolders:
		texture.visible = false
	
func ShowRandomImage(duration: float = 3.0):
	var ranTextureHolder = GetAvailableTextureHolder()
	if(ranTextureHolder == null): return
	
	var ranTexture = LoadRandomTexture(ranTextureHolder)
	SetRandomPositionOnScreen(ranTextureHolder)
	ranTextureHolder.visible = true
	emit_signal("OnRandomImageSetVisible")
	await  get_tree().create_timer(duration,true,false,true).timeout
	ranTextureHolder.visible = false
	emit_signal("OnRandomImageSetInvisible")
	print("SET TIME OUT : " + str(ranTexture))
	
func LoadRandomTexture(textureRect: TextureRect):
	var random_index = randi_range(0,textures.size()-1)
	#randi() % textures.size()
	
	if(random_index == currentIndex):
		LoadRandomTexture(textureRect)
		return
		
	currentIndex = random_index
	var ranTexture = textures[random_index]
	call_deferred("LoadNewTexture",textureRect,ranTexture)
	#LoadNewTexture(textureRect,ranTexture)
	return ranTexture
	
#Set a new CompressedTexture in a TextureRect
func LoadNewTexture(texture: TextureRect, newTexture: CompressedTexture2D):
	
	texture.stretch_mode = TextureRect.STRETCH_SCALE
	texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	
	texture.texture = newTexture
	#newTexture.get_size()
	var newSize = newTexture.get_size() * imageSize
	
	#texture.queue_redraw()
	texture.size = newSize
	
	print("TEXTURE TARGET SIZE: " + str(newSize))
	print("TEXTURE RECT SIZE: " + str(texture.size))
	
func GetAvailableTextureHolder() -> TextureRect:
	for texture in textureHolders:
		if(texture.visible == false): return texture
		
	print("No Holder Available")
	return null
	
#Set a new random position inside the screen for a TextureRect
func SetRandomPositionOnScreen(texture: TextureRect):
	randomize()
	#texture.scale = Vector2.ONE
	
	var screen_size = get_size()
	var image_size = texture.get_size()

	#random limits
	var max_x = screen_size.x - image_size.x
	var max_y = screen_size.y - image_size.y

	# random pos
	var random_x = randi_range(0,max_x)
	var random_y = randi_range(0,max_y)
	#randi() % int(max_y)

	# Set Texture pos
	texture.position = Vector2(random_x, random_y)
	print("TEXTURE POS = " + str(Vector2(random_x, random_y)))
	
	#set scale
	#texture.scale = textureScale
	
func RandomTextureLoop():
	randomize()
	ShowRandomImage()
