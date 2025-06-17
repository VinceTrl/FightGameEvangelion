class_name Spear

extends Node3D

@onready var projectile_spawn_location: Marker3D = $ProjectileSpawnLocation
@onready var animation_player: AnimationPlayer = $Sprite3D/AnimationPlayer
@onready var sprite_3d: Sprite3D = $Sprite3D

var currentDirection

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func SetLookDirection(direction:Vector3):
	currentDirection = direction
	
func SetSpearRotation(direction:Vector3):
	global_rotation.z = lerp_angle(global_rotation.z,atan2(direction.y,direction.x),1)
	
func UpdateSpearRotation(aimDirection:Vector3):
	SetLookDirection(aimDirection)
	SetSpearRotation(currentDirection)
	
func GetShootPosition() -> Vector3:
	return projectile_spawn_location.global_position
	
func ActiveSpear():
	sprite_3d.visible = true
	animation_player.play("SpearIdle")
	
func InactiveSpear():
	sprite_3d.visible = false
	animation_player.play("SpearIdle")
	
func SpearCharge():
	animation_player.play("SpearCharging")
	
func SpearChargeReady():
	animation_player.play("SpearChargeReady")
	
func SpearShoot():
	animation_player.play("SpearShoot")
	await animation_player.animation_finished
	animation_player.play("SpearIdle")
	
