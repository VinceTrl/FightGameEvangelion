class_name Block

extends Node3D

@export var healthPoints:int = 3
@export var canTakeDamage:bool = true
@export var forceToGroundOnReady = true
@export var destroyDelay:float = 0.1
@export var explosionDamageMultiplier:float = 10.0

const AUDIO_SCENE = preload("res://Scenes/Audio/audio_scene.tscn")
const SD_BLOC_DESTROY = preload("res://Assets/Sounds/SFX/DoudouSFX/SD_blocDestroy.wav")

@onready var node_shaker: NodeShaker = $NodeShaker
@onready var ground_magnet: ForceToGround = $GroundMagnet
@onready var audio_hit: AudioStreamPlayer3D = $AudioHit
@onready var vfx_minecraft_bloc_hit: VFXOneShot = $vfx_minecraft_bloc_hit

@export_category("Spawn Settings")
@export var spawner:Spawner
@export_range(0.0,1.0,0.05) var spawnChance:float = 1.0
#@export var spawnItem:SpawnableItem

@export_category("Redstone Settings")
@export var redstoneActive:bool = false
@export var redstoneLink:RedstoneLink

var originBlock:Block

var isDead = false

signal BlockDestroyed

# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	
	if(originBlock):
		pass
	
	ground_magnet.auto_align_on_ready = forceToGroundOnReady
	
	#if(redstoneActive and redstoneLink):
		#redstoneLink.isActive = true
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func TakeDamage(hitboxSource: Hitbox):
	if(!canTakeDamage):return
	#hitboxSource.DealDamage()
	var damage:float = -hitboxSource.damage
	
	if(hitboxSource.type == Hitbox.DamageType.Explosion):
		damage = damage * explosionDamageMultiplier
	elif(hitboxSource.type == Hitbox.DamageType.Volume):
		return
		
	ChangeHealth(damage)
	
func ChangeHealth(healthAmount:int = -1):
	if(isDead): return
	
	node_shaker.NodeShake()
	vfx_minecraft_bloc_hit.EmitAllParticles()
	healthPoints += healthAmount
	if(healthPoints <= 0):
		isDead = true
		#Manager.gameManager.shitpost_gui.ShowRandomImage()
		var audio = AUDIO_SCENE.instantiate()
		get_tree().current_scene.add_child(audio)
		audio.StartAudio(SD_BLOC_DESTROY,0.0)
		
		#Spawn item on death if spawner is referenced
		if(spawner):
			Spawn()
			
		#if(redstoneActive):
			#redstoneLink.ChangePowerState(false)
			#redstoneLink.PropagatePowerFromSource(redstoneLink)
			pass
			
		BlockDestroyed.emit()
		
		await get_tree().create_timer(destroyDelay).timeout
		queue_free()
	else:
		audio_hit.play()
		
func Spawn():
	var spawnRng := randf_range(0.0,1.0)
	if(spawnRng <= spawnChance):
		var item:SpawnableItem = spawner.items.pick_random()
		spawner.SpawnExternalItem(item)
