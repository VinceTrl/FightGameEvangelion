class_name Lever

extends Node3D

@export var isOn:bool = false

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
	
func UpdateRedstonePower():
	redstoneLink.isPowerOn = isOn
	
func UpdateAnimation():
	if(isOn):
		animationPlayer.play("TurnOn")
	else:
		animationPlayer.play("TurnOff")
	pass
