extends Node3D

@export_category("References")
@export var hurtbox:Hurtbox
@export var screenNotifier:VisibleOnScreenNotifier3D
@export var screenMarginDetector:ScreenDetection3D
@export var ballMesh:Node3D
@export var hitSFX:AudioStreamPlayer3D

@export var voiceAudio:AudioStreamRandomizer
const AUDIO_SCENE = preload("res://Scenes/Audio/audio_scene.tscn")



@export_category("Settings")
@export var minLifePoint:int = 1
@export var maxLifePoint:int = 3
var lifePoints: int = 3
@export var minBallSpeed:float = 4.0
@export var maxBallSpeed:float = 8.0

@export_category("Hurt effects")
@export var damageGlitchEffect: GlitchParameters
@export var hurtTime:float = 1
@export var hurtSpeedCurve:Curve
@export var hurtScale:float = 0.5
@export var hurtScaleCurve:Curve

@export_category("Screen Border Bounce settings")
enum BounceType{RandomInverseAngle,InverseContact}
@export var bounceType:BounceType
@export var randomBounceAngleAmount:float = 30

var baseScale:float
var currentDir:Vector3
var currentSpeed:float = 0.0
var canMove:bool = false
var isHurt:bool = false
var timer:SceneTreeTimer

#signals
signal OnSmashBallHurt
signal OnSmashBallDestroyed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lifePoints = randi_range(minLifePoint,maxLifePoint)
	baseScale = ballMesh.scale.y
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
	#ballMesh.global_rotation.z = GetBallRotation()
	SetBallScale()
	
	
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
	return speed
	
func GetSpeedRatio() -> float:
	if(!timer): return 0.0
	if(timer.time_left == 0): return 0.0
	
	var _timeProgress = hurtTime - timer.time_left
	var _progressRatio = _timeProgress/hurtTime
	var _curveValue = hurtSpeedCurve.sample(_progressRatio);
	var _speed = lerp(minBallSpeed,maxBallSpeed,_curveValue)
	return _speed
	
func Move(delta:float):
	if(!canMove):return
	
	var nextPos = ((currentDir * GetCurrentSpeed(GetSpeedRatio())) * delta)
	global_position += nextPos #lerp(global_position,nextPos,0.5)
	#DebugDraw3D.draw_arrow(global_position,global_position + currentDir,Color.REBECCA_PURPLE,0.02)
	
	
func GetBallRotation() -> float:
	return lerp_angle(global_rotation.z,atan2(currentDir.y,currentDir.x),1)
	
func SetBallScale():
	if(!timer):return
	
	if(timer.time_left == 0): ballMesh.scale.y = baseScale
	
	var _timeProgress = hurtTime - timer.time_left
	var _progressRatio = _timeProgress/hurtTime
	var _curveValue = hurtScaleCurve.sample(_progressRatio);
	var _scale = lerp(baseScale,hurtScale,_curveValue)
	
	ballMesh.scale.y = _scale
	
	
func OnHit(hitbox : Hitbox):
	print("SMASH BALL HURT")
	OnSmashBallHurt.emit()
	lifePoints -= hitbox.damage
	
	Manager.timeManager.freezeFrame(0.001,0.1)
	Manager.gameCamera.camShake.AskCamShake("HitShake")
	Manager.postProcessEffects.GlitchEffect(damageGlitchEffect)
	
	
	if(hitbox.owner is PlayerCharacter):
			print("HIT BY PLAYER")
	
	if(lifePoints > 0):
		hitSFX.play()
		var origin := Vector3(hitbox.global_position.x,hitbox.global_position.y,global_position.z)
		currentDir = (global_position - origin).normalized()
		StartHurtTimer()
	else:
		var target:Node3D
		if(hitbox.owner is PlayerCharacter):
			var player := hitbox.owner as PlayerCharacter
			target = Manager.gameManager.GetPlayerOpponent(player)
			print("DESTROY BY PLAYER")
		else:
			target = Manager.gameManager.GetRandomPlayer()
			
		Manager.gameManager.eva.StartSlap(target)
		OnSmashBallDestroyed.emit()
		
		#SFX
		var hitAudio = AUDIO_SCENE.instantiate()
		get_tree().get_root().add_child(hitAudio)
		hitAudio.StartAudio(hitSFX.stream,0.0)
		
		#voice audio
		var audio = AUDIO_SCENE.instantiate()
		get_tree().get_root().add_child(audio)
		audio.StartAudio(voiceAudio)
		
		queue_free()
		
		
func StartHurtTimer():
	isHurt = true
	timer = get_tree().create_timer(hurtTime)
	await timer.timeout
	isHurt = false
