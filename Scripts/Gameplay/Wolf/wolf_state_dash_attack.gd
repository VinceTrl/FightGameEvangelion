extends CharacterState

@export var stateDuration:float = 1.0
@export var dashDuration:float = 1.0

@export var dashDirections:Array[Vector3] = [Vector3.RIGHT,Vector3.LEFT]
@export var dashSpeed:float = 6.0
@export var dashCurve:Curve
@export var hitbox:Hitbox
@export var attackFx:Node3D
@export var attackSignSprite:Sprite3D
@export var attackSign:Node3D
@export var dashAudio:AudioStreamPlayer3D
var isAttacking:bool = false
var timer:SceneTreeTimer
var dashDirection:Vector3

func EnterState():
	stateName = "DASH ATTACK"
	character.movement.currentDirection = Vector3.ZERO # stop moving
	dashDirection = SetDashDirection()
	character.animation.play("AttackAnticipation")
	attackSignSprite.visible = true
	SetRotationToDirection(attackSign,dashDirection)
	attackSign.visible = true
	await character.animation.animation_finished
	attackSign.visible = false
	attackSignSprite.visible = false
	dashAudio.play()
	character.animation.play("Attack")
	attackFx.visible = true
	timer = get_tree().create_timer(stateDuration)
	isAttacking = true
	
	character.flip.ResetFlip()
	character.movement.gravity = 0.0
	character.collision_mask = 0
	
	hitbox.ActiveHitBox()
	Dash(dashDirection)
	pass
	
func ExitState():
	isAttacking = false
	attackFx.visible = false
	attackSign.visible = false
	attackSignSprite.visible = false
	character.global_rotation.z = 0.0
	character.collision_mask = 1
	character.movement.gravity = 6.0
	hitbox.InactiveHitBox()
	pass
	
func ProcessState(delta: float):
	character.flip.ProcessFlip()
	ProcessAttack()
	
func PhysicsProcessState(delta: float):
	pass
	
func ProcessAttack():
	if(isAttacking):
		if(timer.time_left <= 0.0):
			character.ChangeState(stateMachine.Idle)
	
func Dash(dir:Vector3):
	character.movement.ApplyKnockback(dir,dashDuration,dashSpeed,dashCurve)
	SetRotationToDirection(character,dir)
	pass
	
func SetDashDirection():
	var dir:Vector3 = Vector3.ZERO
	if(character.chaseTarget):
		dir = character.GetTargetDirection()
	else:
		dir = dashDirections.pick_random()
		
	return dir
	
func SetRotationToDirection(node:Node3D,direction:Vector3):
	var rotation = node.global_rotation
	node.global_rotation.z = lerp_angle(rotation.z,atan2(direction.y,direction.x),1)
	
