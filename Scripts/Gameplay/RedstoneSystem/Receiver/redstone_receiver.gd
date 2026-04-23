class_name RedstoneReceiver

extends Node3D

@export var redstoneLink:RedstoneLink

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(redstoneLink):
		redstoneLink.TurnedOn.connect(OnTurnedOn)
		redstoneLink.TurnedOff.connect(OnTurnedOff)
		redstoneLink.Updated.connect(OnUpdated)


func OnTurnedOn():
	pass
	
func OnTurnedOff():
	pass
	
func OnUpdated():
	pass
