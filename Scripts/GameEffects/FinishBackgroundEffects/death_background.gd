class_name DeathBackground

extends AnimatedSprite3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var zOffset: float = -1.25

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	call_deferred("ConnectSignals")
	
func ConnectSignals():
	Manager.replayManager.ReplayStart.connect(HideBackground)
	
#func _process(delta: float) -> void:
	#if(Input.is_action_just_pressed("DebugKey")):
		#SetBackgroundOnPlayer(Manager.gameManager.players[0])
#
	#if(Input.is_action_just_released("DebugKey")):
		#HideBackground()
	#pass
		
func PlayRandomAnim():
	var animations = animation_player.get_animation_list()
	var ran = randi_range(0,animations.size()-1)
	var anim =  animations[ran]
	animation_player.play(anim)

func SetRandomAnimation():
	var animations = sprite_frames.get_animation_names()
	var ran = randi_range(0,animations.size()-1)
	var anim =  animations[ran]
	play(anim)
	
func SetBackgroundOnPlayer(_player:PlayerCharacter):
	#SetRandomAnimation()
	PlayRandomAnim()
	var targetPos = Vector3(_player.global_position.x,_player.global_position.y,zOffset)
	global_position = targetPos
	visible = true
	
func HideBackground():
	visible = false
