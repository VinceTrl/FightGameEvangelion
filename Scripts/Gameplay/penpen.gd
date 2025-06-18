extends Node3D

@onready var spawner: Spawner = $Spawner

@onready var hurt_sfx: AudioStreamPlayer3D = $Audio/HurtSFX
@onready var nodeShaker: NodeShaker = $NodeShaker
@onready var timer: Timer = $Timer

@export var healthPoints = 3
@export var hurtTime = 1.0
@export var moveTime = 3.0
@export_range(0.0, 1.0, 0.001) var slapChance = 0.25
@export var moveSpeed:float = 3
@export var startingMoveDirection: Vector3

var animationPlayer: AnimationPlayer
var animationTree: AnimationTree
var hurtbox: Hurtbox
var canTakeDamage = true
var canMove = true
var isTakingDamage = false
var isOutOfScreen = false
var isDead = false
var currentHealthPoint = healthPoints
var currentMoveDirection = startingMoveDirection

signal OnPenpenHurt
signal OnPenpenDeath

func _ready():
	animationPlayer = GetAnimationPlayer(self)
	animationTree = GetAnimationTree(self)
	hurtbox = GetHurtbox(self)
	
	if animationPlayer:
		print("AnimationPlayer found ")
	else:
		print("NO AnimationPlayer Found")
		
	if animationTree:
		print("AnimationTREE found ")
	else:
		print("NO AnimationTREE Found")
		
	if hurtbox:
		hurtbox.OnHurtboxTakeDamage.connect(_on_hurtbox_take_damage)
	else:
		print("!!! HURTBOX NOT FOUND !!!")
		
	currentMoveDirection = startingMoveDirection
	#SetRandomDirection()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#Move(delta)
	MovePenpen(delta)
	#ClampInScreen()

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
	
	
func GetHurtbox(node: Node) -> Hurtbox:
	for child in node.get_children():
		if child is Hurtbox:
			return child
		# Recherche récursive dans les enfants
		var found = GetHurtbox(child)
		if found:
			return found
	return null
	
	
func PenpenSpawnItem():
	Manager.spawnManager.RandomSpawn(spawner)
	
func _on_hurtbox_take_damage(hitbox: Hitbox) -> void:
	if(hitbox.type == Hitbox.DamageType.Volume): return
	
	Hurt(hitbox.damage)
	SetMoveDirection(hitbox.global_position)
	
func Hurt(_damagePoint: int = 1):
	if(!canTakeDamage or isTakingDamage):return
	
	print("PENPEN HURT")
	
	currentHealthPoint -= _damagePoint
	isTakingDamage = true
	canTakeDamage = false
	
	PenpenSpawnItem()
	OnPenpenHurt.emit()
	
	#effects
	nodeShaker.NodeShake()
	hurt_sfx.play()
	Manager.timeManager.freezeFrame()
	Manager.gameCamera.camShake.AskCamShake("HitShake")
	Manager.postProcessEffects.GlitchEffect()
	
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
	Manager.gameManager.eva.StartSlap(global_position)
	isDead = true
	OnPenpenDeath.emit()
	await animationPlayer.animation_finished
	queue_free()
	
func SetMoveDirection(hurtOrigin: Vector3):
	var newDir = global_position - hurtOrigin
	newDir = Vector3(newDir.x,newDir.y,0)
	currentMoveDirection = newDir.normalized()
	PenpenMoveTimer()
	
func SetRandomDirection():
	var ranX = randi_range(-1,1)
	var ranY = randi_range(-1,1)
	
	currentMoveDirection = Vector3(ranX,ranY,0).normalized()

#func MovePenpen(delta):
	#var z_plane := 0.0  # profondeur à laquelle le logo "vit"
	#var camera = Manager.gameCamera.camera
	#
	## Mouvement simple
	#global_position += currentMoveDirection.normalized() * moveSpeed * delta
#
	## Vérifier position à l'écran
	#var screen_pos = camera.unproject_position(global_transform.origin)
#
	#var viewport_size = get_viewport().get_visible_rect().size
#
	## Rebondir sur les bords X (gauche/droite)
	#if screen_pos.x <= 0 or screen_pos.x >= viewport_size.x:
		#currentMoveDirection.x = -currentMoveDirection.x
#
	## Rebondir sur les bords Y (haut/bas)
	#if screen_pos.y <= 0 or screen_pos.y >= viewport_size.y:
		#currentMoveDirection.y = -currentMoveDirection.y
		
		
func MovePenpen(delta):
	global_position += currentMoveDirection.normalized() * moveSpeed * delta
	
func PenpenMoveTimer():
	timer.start(moveTime)
	await timer.timeout
	ChangePenpenDir()
	
func ChangePenpenDir():
	currentMoveDirection = -currentMoveDirection
	PenpenMoveTimer()
