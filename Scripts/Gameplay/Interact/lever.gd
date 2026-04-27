class_name Lever

extends Node3D

@export var isOn:bool = false

@export_group("effect")
@export var freezeFrameDuration:float = 0.05
@export var cameraShake:String = "HitShake"
@export var sprite:Sprite3D
@export var onColor:Color = Color.GREEN
@export var offColor:Color = Color.RED

@export_group("reference")
@export var hurtbox:Hurtbox
@export var redstoneLink:RedstoneLink
@export var animationPlayer:AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UpdateAnimation()
	UpdateRedstonePower()

func ChangeState(on:bool):
	if(isOn == on):return
	isOn = on
	UpdateAnimation()
	pass
	
func TakeDamage(hitbox : Hitbox):
	ChangeState(!isOn)
	UpdateRedstonePower()
	Manager.timeManager.freezeFrame(0.001,freezeFrameDuration)
	Manager.gameCamera.camShake.AskCamShake(cameraShake)
	
func UpdateRedstonePower():
	redstoneLink.isPowerOn = isOn
	
func UpdateAnimation():
	if(isOn):
		animationPlayer.play("TurnOn")
		if(sprite):
			sprite.modulate = onColor
	else:
		animationPlayer.play("TurnOff")
		if(sprite):
			sprite.modulate = offColor
	pass
