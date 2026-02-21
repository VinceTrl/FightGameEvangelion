class_name MovementComponent

extends Node

@export var character:CharacterBody3D

@export_category("movement settings")
@export var speed:float = 2.0
@export var acceleration:float = 0.5
@export var deceleration:float = 1.5
@export var gravity:float = 6.0

var iniSpeed:float
var iniAcceleration:float
var iniDeceleration:float

var currentDirection:Vector3 = Vector3.ZERO
var isMoving:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(!character): push_error("NO CHARACTER REFERENCED FOR MOVEMENT COMPONENT IN " + str(owner,name))
	iniSpeed = speed
	iniAcceleration = acceleration
	iniDeceleration = deceleration
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
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
