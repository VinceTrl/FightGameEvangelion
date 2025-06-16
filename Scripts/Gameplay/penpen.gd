extends Node3D

@onready var spawner: Spawner = $Spawner
@onready var hurtbox: Hurtbox = $NodeShaker/Mesh_Penpen_01/Hurtbox
@onready var hurt_sfx: AudioStreamPlayer3D = $Audio/HurtSFX
@onready var nodeShaker: NodeShaker = $NodeShaker

@export var healthPoints = 3
@export var hurtTime = 1.0
@export_range(0.0, 1.0, 0.001) var slapChance = 0.25

var animationPlayer: AnimationPlayer
var animationTree: AnimationTree
var canTakeDamage = true
var isTakingDamage = false
var isDead = false
var currentHealthPoint = healthPoints

signal OnPenpenHurt
signal OnPenpenDeath

func _ready():
	animationPlayer = GetAnimationPlayer(self)
	animationTree = GetAnimationTree(self)
	
	if animationPlayer:
		print("AnimationPlayer found ")
	else:
		print("NO AnimationPlayer Found")
		
	if animationTree:
		print("AnimationTREE found ")
	else:
		print("NO AnimationTREE Found")

func GetAnimationPlayer(node: Node) -> AnimationPlayer:
	for child in node.get_children():
		if child is AnimationPlayer:
			return child
		# Recherche récursive dans les enfants
		var found = GetAnimationPlayer(child)
		if found:
			return found
	return null
	
func GetAnimationTree(node: Node) -> AnimationTree:
	for child in node.get_children():
		if child is AnimationTree:
			return child
		# Recherche récursive dans les enfants
		var found = GetAnimationTree(child)
		if found:
			return found
	return null
	
	
func PenpenSpawnItem():
	Manager.spawnManager.RandomSpawn(spawner)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_hurtbox_take_damage(hitbox: Hitbox) -> void:
	Hurt(hitbox.damage)
	

func Hurt(_damagePoint: int = 1):
	if(!canTakeDamage or isTakingDamage):return
	
	print("PENPEN HURT")
	
	currentHealthPoint -= _damagePoint
	isTakingDamage = true
	canTakeDamage = false
	
	OnPenpenHurt.emit()
	
	#effects
	nodeShaker.NodeShake()
	hurt_sfx.play()
	Manager.timeManager.freezeFrame()
	Manager.gameCamera.camShake.AskCamShake("HitShake")
	Manager.postProcessEffects.GlitchEffect()
	#animationPlayer.play("")
	
	
	if(currentHealthPoint <= 0):
		randomize()
		var ran = randf_range(0.0,1.0)
		if(ran <= slapChance):
			PenpenDeath()
			return
		else:
			animationPlayer.play("Armature|Hit01")
	else:
		animationPlayer.play("Armature|Hit01")
	
	await get_tree().create_timer(hurtTime,true,false,false).timeout
	
	if(!isDead): animationPlayer.play("Armature|Iddle")
	
	isTakingDamage = false
	canTakeDamage = true
	
	
func PenpenDeath():
	animationPlayer.play("Armature|Dead")
	print("BRUTAL SLAP")
	isDead = true
	OnPenpenDeath.emit()
