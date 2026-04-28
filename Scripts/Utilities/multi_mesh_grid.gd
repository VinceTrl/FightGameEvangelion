@tool

extends MultiMeshInstance3D

@export var grid:Vector2 = Vector2(0.3,0.3)
@export var surface:Vector2 = Vector2(6,12)
@export var meshInstance:Mesh
@export var meshScale := Vector3(50,50,50)
@export var trans:Transform3D
@export var meshBasis:Basis:
	set(base):
		meshBasis = base
		createGrid()

@export var instanceCount:int = 100:
	set(new_count):
		instanceCount = new_count
		createGrid()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	createGrid()
	pass
	
func _process(delta: float) -> void:
	#createGrid()
	pass
	
func createGrid():
	multimesh = MultiMesh.new()
	var pos := GetAllPosition(instanceCount)
	multimesh.transform_format = MultiMesh.TRANSFORM_3D
	multimesh.instance_count = instanceCount
	multimesh.mesh = meshInstance
	multimesh.mesh.mat
	#multimesh.
	
	for i in multimesh.instance_count:
		if(i > pos.size()-1):
			return
		var t:Transform3D = Transform3D(meshBasis, Vector3(pos[i].x,pos[i].y, 0))
		multimesh.set_instance_transform(i,t)
		print("MULTIMESH SET AT POSITION : " + str(t))


func GetAllPosition(count:int = 100) -> Array[Vector3]:
	var positions:Array[Vector3]
	var x = 0
	var y = 0
	
	for i in count:
		y += grid.y
		if(y >= surface.y):
			y = 0
			x += grid.x
			if(x >= surface.x):
				return positions
				
		positions.append(Vector3(x,y,0.0))
				
	return positions
