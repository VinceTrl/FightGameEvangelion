extends Node3D

@export var hitbox:Hitbox
@export var timeToReachTarget:float = 2.0
@export var moveEaseType:Tween.EaseType = Tween.EASE_OUT
@export var moveTransType:Tween.TransitionType = Tween.TRANS_QUART

const EXPLOSION = preload("uid://8mccoxd2fk3f")


var targetPosition:Vector3
var tween:Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hitbox.OnHitWithHurtbox.connect(OnHit)
	pass # Replace with function body.
	
func StartProjectile(targetPos:Vector3):
	targetPosition = targetPos
	#StartMovement()
	await StartMovement()
	Explode()
	
func StartMovement():
	tween = get_tree().create_tween()
	tween.set_ease(moveEaseType)
	tween.set_trans(moveTransType)
	tween.set_parallel(true)
	tween.tween_property(self,"global_position",targetPosition,timeToReachTarget)
	await tween.finished
	
func OnHit(hurtbox:Hurtbox):
	if(tween):
		tween.kill()
	Explode()
	
func Explode():
	var explosion = EXPLOSION.instantiate()
	get_tree().current_scene.add_child(explosion)
	explosion.global_position = global_position
	queue_free()
