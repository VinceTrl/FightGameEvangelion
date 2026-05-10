extends Node3D

@export var kiki:PlayerCharacter
@export var cheeseRoot:Node3D
@export var rotationFactor:float = 6.0
@export var cheeseMesh:Node3D
@export var kiki1Material:Material
@export var kiki2Material:Material

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if kiki.playerID == 2:
		cheeseMesh.set_surface_override_material(0, kiki2Material)
	else:
		cheeseMesh.set_surface_override_material(0, kiki1Material)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	ProcessCheeseRoll(delta)
	
func ProcessCheeseRoll(delta:float):
	if(!kiki.isCheese):return
	var vel := kiki.velocity.x
	var rotation_amount = vel * rotationFactor
	cheeseRoot.rotate_z(-rotation_amount * delta)
	pass
