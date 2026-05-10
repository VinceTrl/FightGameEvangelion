extends Node3D

@export var lifeTime: float = 10.0
@export var infinite = false
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var shrek_animation_player: AnimationPlayer = $Visual/NodeShaker/Shrek/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#play anim
	animation_player.play("ShrekSpawn")
	LifeTime()
	await animation_player.animation_finished
	shrek_animation_player.play("mixamo_com")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func LifeTime():
	if(!infinite):
		await get_tree().create_timer(lifeTime,true,false,false).timeout
		queue_free()
