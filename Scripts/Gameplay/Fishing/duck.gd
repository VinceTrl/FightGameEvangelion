extends Node3D

@onready var fish_hook_target: FishHookTarget = $FishHookTarget
@onready var hitbox: Hitbox = $Hitbox
@onready var node_shaker: NodeShaker = $Visual/NodeShaker
@onready var visual: Node3D = $Visual
@onready var vfx_fire: ParticlesHolder = $Visual/NodeShaker/duck/VFX_Fire01_mecha


@export var attackDelay:float = 1 
@export var attackSpeed:float = 5

@export var moveDirection: Vector3 = Vector3.RIGHT
@export var moveSpeed:float = 1

var tween
var canMove = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hitbox.InactiveHitBox()
	HandleMeshFlip(moveDirection)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	MoveDuck(delta)

func MoveDuck(delta:float):
	if(!canMove): return
	global_position += moveDirection * (moveSpeed * delta)

func ChangeDirection():
	moveDirection = -moveDirection
	HandleMeshFlip(moveDirection)
	
func HandleMeshFlip(direction:Vector3):
	visual.scale.x = direction.normalized().x

func on_fish_hook_target_caught() -> void:
	canMove = false


func on_fish_hook_target_released() -> void:
	LaunchAttack()
	
func LaunchAttack():
	node_shaker.NodeShake()
	vfx_fire.EmitParticles()
	var target = GetPlayerTarget()
	var newDirection = (target.global_position - global_position).normalized()
	HandleMeshFlip(newDirection)
	await get_tree().create_timer(attackDelay,true,false,false).timeout
	AttackPlayer(target)
	
func GetPlayerTarget() -> PlayerCharacter:
	if(fish_hook_target.hookHolder != null):
		var player = fish_hook_target.hookHolder.fishingRodOwner.lastPlayer 
		if(player != null):
			hitbox.owner_id = player.playerID
			return Manager.gameManager.GetPlayerOpponent(player)
		else:
			return Manager.gameManager.GetRandomPlayer()
	else:
		return Manager.gameManager.GetRandomPlayer()
	
func AttackPlayer(_playerTarget:PlayerCharacter):
	var targetPosition = _playerTarget.global_position
	var time = Global.GetTimeToReachTargetWithSpeed(global_position,targetPosition,attackSpeed)
	hitbox.ActiveHitBox()
	await MoveToLocation(targetPosition,time)
	hitbox.InactiveHitBox()
	queue_free()
	
func MoveToLocation(_targetPos:Vector3,_time:float):

	if(tween):
		tween.kill()
		
	tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.set_parallel(true)
	
	tween.tween_property(self,"global_position",_targetPos,_time)
	
	await tween.finished


func _on_visible_on_screen_notifier_3d_screen_entered() -> void:
	pass # Replace with function body.


func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	ChangeDirection()
	pass # Replace with function body.
