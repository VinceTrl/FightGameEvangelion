class_name ShitpostWindow

extends Control

@export var imageSize:float = 0.4
@export var windowPanel:PanelContainer
@export var texture:Texture2D
@export var texture_rect: TextureRect

@export_group("Panel settings")
@export var glitch_style: StyleBox
@export var glitch_minSize:Vector2i = Vector2i(350,350)
@export var shitpost_style: StyleBox
@export var shitpost_minSize:Vector2i = Vector2i(300,300)
@export var gaucho_style: StyleBox
@export var gaucho_minSize:Vector2i = Vector2i(600,600)
@export var rdr_style: StyleBox
@export var rdr_minSize:Vector2i = Vector2i(300,300)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	windowPanel.add_theme_stylebox_override("panel",gaucho_style)
	windowPanel.custom_minimum_size = gaucho_minSize
	#LoadNewTexture(texture_rect,texture)
	pass # Replace with function body.
	
	
func SetPanel(shitpost:ShitpostImage):
	windowPanel.remove_theme_stylebox_override("panel")
	match shitpost.type:
		Global.ShitpostType.Glitch:
			windowPanel.add_theme_stylebox_override("panel",glitch_style)
			windowPanel.custom_minimum_size = glitch_minSize
		Global.ShitpostType.Shitpost:
			windowPanel.add_theme_stylebox_override("panel",shitpost_style)
			windowPanel.custom_minimum_size = shitpost_minSize
		Global.ShitpostType.RDR:
			windowPanel.add_theme_stylebox_override("panel",rdr_style)
			windowPanel.custom_minimum_size = rdr_minSize
		Global.ShitpostType.Gaucho:
			windowPanel.add_theme_stylebox_override("panel",gaucho_style)
			windowPanel.custom_minimum_size = gaucho_minSize
	
	LoadNewTexture(shitpost.texture,shitpost.size)

#Set a new CompressedTexture in a TextureRect
func LoadNewTexture(newTexture: Texture2D,size:float = imageSize,texture: TextureRect = texture_rect):
	
	#texture.stretch_mode = TextureRect.STRETCH_SCALE
	#texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	
	texture.texture = newTexture
	#newTexture.get_size()
	var newSize = newTexture.get_size() * size
	
	#texture.queue_redraw()
	windowPanel.size = newSize
	#texture.size = newSize
	
	print("TEXTURE TARGET SIZE: " + str(newSize))
	print("TEXTURE RECT SIZE: " + str(texture.size))
