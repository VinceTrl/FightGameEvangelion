extends Node3D

@export var block:BlockLiquid
@export var fullBlockMesh:Node3D
@export var sideBlockMesh:Node3D
@export var scalePivot: Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(block.isSide):
		sideBlockMesh.visible = true
		fullBlockMesh.visible = false
	call_deferred("SetScale")
	pass # Replace with function body.
	
	
	
func SetScale():
	if(!block):
		push_error("NO BLOCK REFERENCED IN : " + str(owner.name))
		return
	
	if(block.originBlock and block.isSide):
		#check if origin block is left
		if(block.originBlock.global_position.x > block.global_position.x):
			scalePivot.scale.x = -1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
