class_name bumper
extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered",OnObjectEnterArea)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
	
func OnObjectEnterArea(object:Node3D):
	print("OBJECT ENTER : " + str(object))
	
	if(object is PlayerCharacter):
		object as PlayerCharacter
		object.ChangeState(object.States.Jump)
