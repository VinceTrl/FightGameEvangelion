extends Node3D

@export var healthPoints:int = 3
@export var canTakeDamage:bool = true
@export var forceToGroundOnReady = true
@export var destroyDelay:float = 0.1

const AUDIO_SCENE = preload("res://Scenes/Audio/audio_scene.tscn")
const SD_BLOC_DESTROY = preload("res://Assets/Sounds/SFX/DoudouSFX/SD_blocDestroy.wav")

@onready var node_shaker: NodeShaker = $NodeShaker
@onready var ground_magnet: ForceToGround = $GroundMagnet
@onready var audio_hit: AudioStreamPlayer3D = $AudioHit

var isDead = false

# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	ground_magnet.auto_align_on_ready = forceToGroundOnReady
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func TakeDamage(hitboxSource: Hitbox):
	if(!canTakeDamage):return
	#hitboxSource.DealDamage()
	ChangeHealth(-hitboxSource.damage)
	
func ChangeHealth(healthAmount:int = -1):
	if(isDead): return
	
	node_shaker.NodeShake()
	healthPoints += healthAmount
	if(healthPoints <= 0):
		isDead = true
		#Manager.gameManager.shitpost_gui.ShowRandomImage()
		var audio = AUDIO_SCENE.instantiate()
		get_tree().current_scene.add_child(audio)
		audio.StartAudio(SD_BLOC_DESTROY,0.0)
		await get_tree().create_timer(destroyDelay).timeout
		queue_free()
	else:
		audio_hit.play()
