extends Node3D

@export var kiki:PlayerCharacter
@export var cheeseRoot:Node3D
@export var rotationFactor:float = 6.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	ProcessCheeseRoll(delta)
	
func ProcessCheeseRoll(delta:float):
	if(!kiki.isCheese):return
	var vel := kiki.velocity.x
	var rotation_amount = vel * rotationFactor
	cheeseRoot.rotate_z(-rotation_amount * delta)
	pass
