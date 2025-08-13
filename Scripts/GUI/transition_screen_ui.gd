extends Control

@onready var sprite: AnimatedSprite2D = $CanvasLayer/CenterContainer/AnimatedSprite2D

var animationProgress: float = 0.0

const transitionFullScreenProgress: float = 0.15
var transitionIsOnFullScreen: bool = false

const transitionAlmostFinishedProgress: float = 0.80
var transitionIsAlmostFinished: bool = false

signal OnTransitionStart
signal OnTransitionEnd
signal OnTransitionReachFullVisibleFrames
signal OnTransitionAlmostFinished

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AdaptSpriteSize()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	animationProgress = GetAnimProgress()

func StartTransition():
	AdaptSpriteSize()
	sprite.visible = true
	sprite.play("transition")
	emit_signal("OnTransitionStart")


	#await sprite.frame == 46
	#print("TRANSITION REACHES FRAME 46")
	#emit_signal("OnTransitionEnd")
	
	await sprite.animation_finished
	emit_signal("OnTransitionEnd")
	sprite.visible = false
	queue_free()
	print("TRANSITION DELETE ITSELF")
	
func GetAnimProgress():
	var progress = float(sprite.frame) / float(sprite.sprite_frames.get_frame_count("transition"))
	#print("TRANSITION CURRENT FRAME : " + str(sprite.frame ))
	#print("TRANSITION FRAME COUNT : " + str(sprite.sprite_frames.get_frame_count("transition")))
	#print("TRANSITION PROGRESS : " + str(progress))
	
	if(progress >= transitionFullScreenProgress and !transitionIsOnFullScreen):
		transitionIsOnFullScreen = true
		emit_signal("OnTransitionReachFullVisibleFrames")
		print("TRANSITION EMIT VISIBLE SIGNAL : " + str(progress))
		
	if(progress >= transitionAlmostFinishedProgress and !transitionIsAlmostFinished):
		transitionIsAlmostFinished = true
		emit_signal("OnTransitionAlmostFinished")
		print("TRANSITION EMIT ALMOST FINISHED SIGNAL : " + str(progress))
		
	return progress

func AdaptSpriteSize():
	var screen_size = get_viewport_rect().size
	#var sprite_texture_size = sprite.sprite_frames.get_frame("transition", 0).get_size()
	var sprite_texture_size = sprite.sprite_frames.get_frame_texture("transition", 0).get_size()
	sprite.scale = screen_size / sprite_texture_size
	sprite.position = get_viewport_rect().size / 2
	
