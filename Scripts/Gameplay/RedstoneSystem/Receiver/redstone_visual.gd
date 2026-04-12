extends RedstoneReceiver

@export var alwaysHidden:bool = false
@export var visualRootNode:Node3D

func _ready() -> void:
	super()
	if(redstoneLink.isActive):
		visualRootNode.visible = true
	else:
		visualRootNode.visible = false
		

func OnTurnedOn():
	visualRootNode.visible = true
	pass
	
func OnTurnedOff():
	visualRootNode.visible = false
	pass
