class_name ShitpostWindow

extends Control

@export var imageSize:float = 0.4
@export var windowPanel:PanelContainer
@export var texture:Texture2D
@export var texture_rect: TextureRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#LoadNewTexture(texture_rect,texture)
	pass # Replace with function body.

#Set a new CompressedTexture in a TextureRect
func LoadNewTexture(newTexture: Texture2D,texture: TextureRect = texture_rect):
	
	#texture.stretch_mode = TextureRect.STRETCH_SCALE
	#texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	
	texture.texture = newTexture
	#newTexture.get_size()
	var newSize = newTexture.get_size() * imageSize
	
	#texture.queue_redraw()
	windowPanel.size = newSize
	#texture.size = newSize
	
	print("TEXTURE TARGET SIZE: " + str(newSize))
	print("TEXTURE RECT SIZE: " + str(texture.size))
