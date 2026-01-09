extends Node3D

@export_category("References")
@export var hurtbox:Hurtbox
@export var screenNotifier:VisibleOnScreenNotifier3D
@export var screenMarginDetector:ScreenDetection3D

@export_category("Settings")
@export var lifePoints: int = 3
@export var minBallSpeed:float = 4.0
@export var maxBallSpeed:float = 8.0
@export var hurtTime:float = 1

@export_category("Screen Border Bounce settings")
enum BounceType{RandomInverseAngle,InverseContact}
@export var bounceType:BounceType
@export var randomBounceAngleAmount:float = 30

var currentDir:Vector3
var currentSpeed:float = 0.0
var canMove:bool = false
var isHurt:bool = false

#signals
signal OnSmashBallHurt
signal OnSmashBallDestroyed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ConnectSignals()
	SetRandomDirection()
	canMove = true
	
	
func ConnectSignals():
	hurtbox.OnHurtboxTakeDamage.connect(OnHit)
	screenNotifier.screen_exited.connect(SetOppositeDirection)
	screenMarginDetector.ExitScreenMargin.connect(OnExitMargins)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Move(delta)
	
	
func OnExitMargins(dir:ScreenDetection3D.ScreenDirection):
	print("DIR :" + str(dir))
	
	match bounceType:
		BounceType.RandomInverseAngle:
			var range:float = randomBounceAngleAmount
			ChangeDirectionInAngleRadius(-range,range)
		BounceType.InverseContact:
			match dir:
				ScreenDetection3D.ScreenDirection.Up:
					HitScreenBorder(Vector3.DOWN)
				ScreenDetection3D.ScreenDirection.Down:
					HitScreenBorder(Vector3.UP)
				ScreenDetection3D.ScreenDirection.Left:
					HitScreenBorder(Vector3.RIGHT)
				ScreenDetection3D.ScreenDirection.Right:
					HitScreenBorder(Vector3.LEFT)
	

			
	#SetOppositeDirection()
	
func SetRandomDirection():
	randomize()
	var ran_x = randf_range(-1,1)
	var ran_y = randf_range(-1,1)
	currentDir = Vector3(ran_x,ran_y,0.0).normalized()
	print("SMASH BALL CHANGE DIRECTION : " + str(currentDir))
	
func SetOppositeDirection():
	var dir := currentDir * -1
	currentDir = dir.normalized()
	print("SMASH BALL OUT OF SCREEN : " + str(dir))
	
func ChangeDirectionInAngleRadius(minAngle:float,maxAngle:float):
	var dir := currentDir.rotated(Vector3.FORWARD,deg_to_rad(180 + randf_range(minAngle,maxAngle)))
	currentDir = dir.normalized()
	print("Change dir with random angle: " + str(dir))
	
func HitScreenBorder(normal:Vector3):
	print("hit screen border")
	var newDir = -2*(currentDir.dot(normal)) * normal + currentDir
	currentDir = newDir.normalized()
	
func GetCurrentSpeed(speedRatio:float) -> float:
	var speed:float = lerp(minBallSpeed,maxBallSpeed,speedRatio)
	print("SPEED :" + str(speed))
	return speed
	
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
		var origin := Vector3(hitbox.global_position.x,hitbox.global_position.y,global_position.z)
		currentDir = (global_position - origin).normalized()
	else:
		OnSmashBallDestroyed.emit()
		queue_free()
