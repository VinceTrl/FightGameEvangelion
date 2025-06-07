extends Node3D

@export var fadeTime: float = 1.0
@export var displayTime: float = 1.25

var images: Array[TextureRect]
@onready var textures: Control = $Control/CanvasLayer/Textures
@onready var background: TextureRect = $Control/CanvasLayer/Background

var currentIndex: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#get all images
	for texture in textures.get_children():
		if(texture is TextureRect):
			images.append(texture)
			
	HideAll()
	
	fade_in_texture(background)
	await onFadeInCompleted
	NextImage()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func HideAll():
	#set all images transparent
	for image in images:
		image.modulate.a = 0.0

func NextImage():
	if currentIndex + 1 >= images.size():
		await get_tree().create_timer(displayTime).timeout
		fade_out_texture(images[currentIndex])
		await onFadeOutCompleted
		fade_out_texture(background)
		await onFadeOutCompleted
		queue_free()
		return  # Fin
		
	if(currentIndex == 0):
		fade_in_texture(images[currentIndex])
		await onFadeInCompleted

	await get_tree().create_timer(displayTime).timeout

	# Lancer en parallèle : fade-out de l’actuel et fade-in du suivant
	fade_out_texture(images[currentIndex])
	currentIndex += 1
	fade_in_texture(images[currentIndex])

	# Planifier encore
	NextImage()

func fade_in_texture(texture: TextureRect):
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(texture, "modulate:a", 1.0, fadeTime)
	emit_signal("onFadeInStarted",texture)
	await tween.finished
	emit_signal("onFadeInCompleted",texture)
	
signal onFadeInStarted(texture: TextureRect)
signal onFadeInCompleted(texture: TextureRect)

func fade_out_texture(texture: TextureRect):
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(texture, "modulate:a", 0.0, fadeTime)
	emit_signal("onFadeOutStarted",texture)
	await tween.finished
	emit_signal("onFadeOutCompleted",texture)
	
signal onFadeOutStarted(texture: TextureRect)
signal onFadeOutCompleted(texture: TextureRect)
