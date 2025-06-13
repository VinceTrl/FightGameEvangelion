extends Control

@export var textureScale: Vector2 = Vector2.ONE
@export var textures: Array[CompressedTexture2D] = []
@onready var static_texture: TextureRect = $CanvasLayer/StaticTexture

var currentIndex

signal OnRandomImageSetVisible
signal OnRandomImageSetInvisible

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ResetTexture()
	RandomTextureLoop()
	OnRandomImageSetInvisible.connect(RandomTextureLoop)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func ResetTexture():
	static_texture.visible = false
	
func ShowRandomImage(duration: float = 3.0):
	var ranTexture = LoadRandomTexture()
	SetRandomPositionOnScreen(static_texture)
	static_texture.visible = true
	emit_signal("OnRandomImageSetVisible")
	await  get_tree().create_timer(duration,true,false,true).timeout
	static_texture.visible = false
	emit_signal("OnRandomImageSetInvisible")
	print("SET TIME OUT : " + str(ranTexture))
	
func LoadRandomTexture():
	var random_index = randi() % textures.size()
	
	if(random_index == currentIndex):
		LoadRandomTexture()
		return
		
	currentIndex = random_index
	var ranTexture = textures[random_index]
	LoadNewTexture(static_texture,ranTexture)
	return ranTexture
	

func LoadNewTexture(texture: TextureRect, newTexture: CompressedTexture2D):
	texture.texture = newTexture
	print("SET TEXTURE : " + str(newTexture))
	
func SetRandomPositionOnScreen(texture: TextureRect):
	
	texture.scale = Vector2.ONE
	
	var screen_size = get_size()
	var image_size = texture.get_size()

	#random limits
	var max_x = screen_size.x - image_size.x
	var max_y = screen_size.y - image_size.y

	# random pos
	var random_x = randi() % int(max_x)
	var random_y = randi() % int(max_y)

	# Set Texture pos
	texture.position = Vector2(random_x, random_y)
	
	#set scale
	texture.scale = textureScale
	
func RandomTextureLoop():
	randomize()
	ShowRandomImage()
