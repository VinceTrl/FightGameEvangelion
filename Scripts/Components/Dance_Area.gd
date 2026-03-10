extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(OnBodyEntered)
	pass # Replace with function body.
	
	
func OnBodyEntered(body: Node3D):
	if(!body):return
	
	#Set Dance to pyramid head
	if(body is PyramidHead):
		body.ChangeState(body.stateMachine.InfiniteDance)
