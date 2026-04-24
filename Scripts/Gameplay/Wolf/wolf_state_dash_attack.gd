extends CharacterState

@export var stateDuration:float = 1.0
@export var dashDuration:float = 1.0

@export var dashDirections:Array[Vector3] = [Vector3.RIGHT,Vector3.LEFT]
@export var dashSpeed:float = 6.0
@export var dashCurve:Curve
@export var hitbox:Hitbox
@export var attackFx:Node3D
var timer:SceneTreeTimer

func EnterState():
	stateName = "DAHS ATTACK"
	character.movement.currentDirection = Vector3.ZERO # stop moving
	
	character.animation.play("Attack")
	attackFx.visible = true
	timer = get_tree().create_timer(stateDuration)
	
	character.flip.ResetFlip()
	character.movement.gravity = 0.0
	character.collision_mask = 0
	
	hitbox.ActiveHitBox()
	Dash()
	pass
	
func ExitState():
	attackFx.visible = false
	character.global_rotation.z = 0.0
	character.collision_mask = 1
	character.movement.gravity = 6.0
	hitbox.InactiveHitBox()
	pass
	
func ProcessState(delta: float):
	character.flip.ProcessFlip()
	if(timer.time_left <= 0.0):
		character.ChangeState(stateMachine.Idle)
	
func PhysicsProcessState(delta: float):
	pass
	
func Dash():
	var dir:Vector3 = Vector3.ZERO
	if(character.chaseTarget):
		dir = character.GetTargetDirection()
	else:
		dir = dashDirections.pick_random()
		
	character.movement.ApplyKnockback(dir,dashDuration,dashSpeed,dashCurve)
	SetRotationToDirection(dir)
	pass
	
func SetRotationToDirection(direction:Vector3):
	var rotation = character.global_rotation
	character.global_rotation.z = lerp_angle(rotation.z,atan2(direction.y,direction.x),1)
	
