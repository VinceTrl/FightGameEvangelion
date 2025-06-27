extends Node3D

@onready var spawner: Spawner = $Spawner

@onready var hurt_sfx: AudioStreamPlayer3D = $Audio/HurtSFX
@onready var nodeShaker: NodeShaker = $NodeShaker
@onready var timer: Timer = $Timer

@export var healthPoints = 3
@export var hurtTime = 1.0
@export var moveTime = 3.0
@export_range(0.0, 1.0, 0.001) var slapChance = 0.25
@export var slapDelay:float = 1.25
@export var moveSpeed:float = 3
@export var startingMoveDirection: Vector3
@export var moveEaseType:Tween.EaseType = Tween.EASE_IN_OUT
@export var moveTransType:Tween.TransitionType = Tween.TRANS_LINEAR
@export var moveTowardsLocation:bool = true

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
var locations:Array[PenpenLocation]
var targetLocation:PenpenLocation
var tween
var evaTarget:Node3D

signal OnPenpenHurt
signal OnPenpenDeath
signal OnMoveStart
signal OnMoveEnd

func _ready():
	animationPlayer = GetAnimationPlayer(self)
	animationTree = GetAnimationTree(self)
	hurtbox = GetHurtbox(self)
	GetAllPenpenLocations()
	
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
		
	#currentMoveDirection = startingMoveDirection
	#SetRandomDirection()
	global_position = GetRandomLocation().global_position
	OnMoveEnd.connect(MovePenpenToLocation)
	MovePenpenToLocation()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#Move(delta)
	#MovePenpen(delta)
	#ClampInScreen()
	pass

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
	
func GetAllPenpenLocations():
	var nodes = get_tree().get_nodes_in_group("PenpenLocation")
	for node in nodes:
		if(node is PenpenLocation):
			locations.append(node)
	
func PenpenSpawnItem():
	Manager.spawnManager.RandomSpawn(spawner,spawner.items)
	
func _on_hurtbox_take_damage(hitbox: Hitbox) -> void:
	if(hitbox.type == Hitbox.DamageType.Volume): return
	
	Hurt(hitbox)
	#SetMoveDirection(hitbox.global_position)
	
func Hurt(_hitbox: Hitbox):
	if(!canTakeDamage or isTakingDamage):return
	if(_hitbox == null): return
	
	print("PENPEN HURT")
	
	currentHealthPoint -= _hitbox.damage
	isTakingDamage = true
	canTakeDamage = false
	
	if(_hitbox.type == Hitbox.DamageType.Melee):
		evaTarget = _hitbox.owner
	
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
	isDead = true
	OnPenpenDeath.emit()
	
	await get_tree().create_timer(slapDelay,false,false,false).timeout
	var slapTarget = GetSlapTarget()
	Manager.gameManager.eva.StartSlap(slapTarget)
	
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
	
func GetRandomLocation()-> PenpenLocation:
	randomize()
	var ranIndex = randi_range(0,locations.size()-1)
	return locations[ranIndex]
	
func GetTweenTime(targetPosition:Vector3) -> float:
	var distance = position.distance_to(targetPosition)
	return distance / moveSpeed
	
func GetSlapLocation()-> Vector3:
	if(evaTarget):
		return evaTarget.global_position
	else:
		return global_position
		
		
func GetSlapTarget()-> Node3D:
	if(evaTarget and evaTarget is PlayerCharacter):
		return evaTarget
	else:
		var target = Node3D.new()
		get_tree().current_scene.add_child(target)
		target.global_position = global_position
		return target
	
func GoTowardsLocation(targetPosition: Vector3,travelTime: float = 1.0):
	if(tween):
		tween.kill()
		
	tween = get_tree().create_tween()
	tween.set_ease(moveEaseType)
	tween.set_trans(moveTransType)
	tween.set_parallel(true)
	
	tween.tween_property(self,"global_position:x",targetPosition.x,travelTime)
	tween.tween_property(self,"global_position:y",targetPosition.y,travelTime)
	tween.tween_property(self,"global_position:z",targetPosition.z,travelTime)
		
	OnMoveStart.emit()
	await tween.finished
	OnMoveEnd.emit()
		
func MovePenpenToLocation():
	targetLocation = GetRandomLocation()
	var targetPos = targetLocation.global_position
	var time = GetTweenTime(targetPos)
	GoTowardsLocation(targetPos,time)
	
	
func MovePenpen(delta):
	global_position += currentMoveDirection.normalized() * moveSpeed * delta
	
func PenpenMoveTimer():
	timer.start(moveTime)
	await timer.timeout
	ChangePenpenDir()
	
func ChangePenpenDir():
	currentMoveDirection = -currentMoveDirection
	PenpenMoveTimer()
