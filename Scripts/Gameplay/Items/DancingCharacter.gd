extends Node3D

@export var anim_player:AnimationPlayer
@export var minDanceDuration:float = 5.0
@export var maxDanceDuration:float = 12.0

@export var animations:PackedStringArray
var currentAnim:String = "NONE"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#animations = anim_player.get_animation_list()
	SetNextAnimation()
	AnimationTimer()
	pass # Replace with function body.
	
func AnimationTimer():
	var time := randf_range(minDanceDuration,maxDanceDuration)
	await get_tree().create_timer(time).timeout
	SetNextAnimation()
	AnimationTimer()
	
func SetNextAnimation():
	var animRng := randi_range(0,animations.size()-1)
	var animation := animations[animRng]
	if(currentAnim != animation):
		anim_player.play(animation)
		currentAnim = animation
