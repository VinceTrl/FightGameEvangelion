class_name Bumper
extends Area3D

@export var bounceForce: float = 6
@export var forceBounceOnUpVector = true

signal OnBumperStart

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
		var dir = object.global_position - global_position
		
		if(forceBounceOnUpVector):
			dir = global_transform.basis.y
			
		object.SetBounceState(dir.normalized(),bounceForce)
		OnBumperStart.emit()
