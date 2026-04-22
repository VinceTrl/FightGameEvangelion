class_name MovementComponent

extends Node

@export var character:CharacterBody3D

@export_category("Movement settings")
@export var speed:float = 2.0
@export var acceleration:float = 0.5
@export var deceleration:float = 1.5

@export_category("Jump settings")
@export var jumpVelocity:float = 4.0
@export var gravity:float = 6.0

var iniSpeed:float
var iniAcceleration:float
var iniDeceleration:float

var currentDirection:Vector3 = Vector3.ZERO
var isMoving:bool = false

@export_category("Knockback settings")
@export var knockbackCurve:Curve = preload("uid://baqrkrpn6ctn8")
@export var knockbackTime:float = 1.0
@export var knockbackSpeed:float = 6.0

var isKnockback:bool = false
var knockbackTimer:SceneTreeTimer
var knockbackDirection:Vector3
var knockbackForce:float
var forceCurve:Curve


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(!character): push_error("NO CHARACTER REFERENCED FOR MOVEMENT COMPONENT IN " + str(owner,name))
	iniSpeed = speed
	iniAcceleration = acceleration
	iniDeceleration = deceleration
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	if(isKnockback):
		ProcessKnockback()
		
	ProcessMovement()
	ProcessGravity(delta)
		
	character.move_and_slide()
	
func ProcessMovement():
	var moveDirectionX = currentDirection.x
	
	if moveDirectionX != 0:
		character.velocity.x = move_toward(character.velocity.x,moveDirectionX * speed,acceleration)
	else:
		character.velocity.x = move_toward(character.velocity.x,moveDirectionX * speed,deceleration)
	
	if character.velocity.x != 0:
		isMoving = true
	else:
		isMoving = false
		
func ProcessGravity(delta: float, gravity: float = gravity):
	if (!character.is_on_floor()):
		character.velocity.y -= gravity * delta
		
func ResetSpeed():
	speed = iniSpeed
	acceleration = iniAcceleration
	deceleration = iniDeceleration
	
func ApplyKnockback(direction:Vector3,duration:float = knockbackTime,force:float = knockbackSpeed,curve:Curve=knockbackCurve):
	knockbackTimer = get_tree().create_timer(duration)
	knockbackDirection = direction
	knockbackForce = force
	forceCurve = curve
	isKnockback = true
	
func ProcessKnockback():
	if(!isKnockback):return
	
	if knockbackTimer.time_left <= 0: 
		isKnockback = false
	else:
		speed = GetKnockbackSpeed()
		currentDirection = knockbackDirection

func GetKnockbackSpeed() -> float:
	if(knockbackTimer.time_left == 0): return 0.0
	
	var _timeProgress = knockbackTime - knockbackTimer.time_left
	var _progressRatio = _timeProgress/knockbackTime
	var _curveValue = forceCurve.sample(_progressRatio);
	var _knockbackSpeed = lerp(0.0,knockbackForce,_curveValue)
	
	return _knockbackSpeed
	
func Jump():
	if(character.is_on_floor()):
		character.velocity.y = jumpVelocity
