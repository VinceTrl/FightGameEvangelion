extends Control

@onready var sprite: AnimatedSprite2D = $CanvasLayer/CenterContainer/AnimatedSprite2D

signal OnTransitionStart
signal OnTransitionEnd

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AdaptSpriteSize()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func StartTransition():
	AdaptSpriteSize()
	sprite.visible = true
	sprite.play("transition")
	emit_signal("OnTransitionStart")
	
	await sprite.animation_finished
	
	sprite.visible = false
	emit_signal("OnTransitionEnd")

func AdaptSpriteSize():
	var screen_size = get_viewport_rect().size
	#var sprite_texture_size = sprite.sprite_frames.get_frame("transition", 0).get_size()
	var sprite_texture_size = sprite.sprite_frames.get_frame_texture("transition", 0).get_size()
	sprite.scale = screen_size / sprite_texture_size
	sprite.position = get_viewport_rect().size / 2
	
