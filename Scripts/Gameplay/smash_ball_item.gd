extends Node3D

@export_category("References")
@export var hurtbox:Hurtbox
@export var screenNotifier:VisibleOnScreenNotifier3D

@export_category("Settings")
@export var lifePoints: int = 3
@export var minSpeed:float = 1.0
@export var maxSpeed:float = 3.0
@export var hurtTime:float = 1

var currentDir:Vector3
var currentSpeed:float = 1.0
var canMove:bool = false
var isHurt:bool = false

#signals
signal OnSmashBallHurt
signal OnSmashBallDestroyed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ConnectSignals()
	ChangeDirection()
	canMove = true
	
	
func ConnectSignals():
	hurtbox.OnHurtboxTakeDamage.connect(OnHit)
	screenNotifier.screen_exited.connect(SetOppositeDirection)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Move(delta)
	
func ChangeDirection():
	randomize()
	var ran_x = randf_range(-1,1)
	var ran_y = randf_range(-1,1)
	currentDir = Vector3(ran_x,ran_y,0.0).normalized()
	print("SMASH BALL CHANGE DIRECTION : " + str(currentDir))
	
func SetOppositeDirection():
	var dir := currentDir * -1
	currentDir = dir.normalized()
	print("SMASH BALL OUT OF SCREEN : " + str(dir))
	
func GetCurrentSpeed(speedRatio:float) -> float:
	return lerpf(minSpeed,maxSpeed,speedRatio)
	
func Move(delta:float):
	if(!canMove):return
	
	var nextPos = ((currentDir * GetCurrentSpeed(currentSpeed)) * delta)
	global_position += nextPos #lerp(global_position,nextPos,0.5)
	DebugDraw3D.draw_arrow(global_position,global_position + currentDir,Color.REBECCA_PURPLE,0.2)
	
func OnHit(hitbox : Hitbox):
	print("SMASH BALL HURT")
	OnSmashBallHurt.emit()
	lifePoints -= hitbox.damage
	
	if(lifePoints > 0):
		ChangeDirection()
		pass
	else:
		OnSmashBallDestroyed.emit()
		queue_free()
