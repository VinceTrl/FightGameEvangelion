@tool
class_name MultiMeshGrid
extends MultiMeshInstance3D

@export var grid:Vector2 = Vector2(0.3,0.3):
	set(g):
		grid = g
		createGrid()

@export var surface:Vector2 = Vector2(3,3):
	set(s):
		surface = s
		createGrid()
		
@export var baseMesh:Mesh = preload("uid://dt2uhuqsydft1"):
	set(bm):
		baseMesh = bm
		createGrid()

@export var meshMaterial:Material = preload("uid://bpwv7bubet4"):
	set(mat):
		meshMaterial = mat
		createGrid()


@export var meshBasis:Basis:
	set(base):
		meshBasis = base
		createGrid()

@export var instanceCount:int = 100:
	set(new_count):
		instanceCount = new_count
		createGrid()
		
var meshInstance:Mesh

func createMesh(mesh:Mesh):
	var localMesh := mesh.duplicate()
	
	for surface in localMesh.get_surface_count():
		localMesh.surface_set_material(surface,meshMaterial)
		
	meshInstance = localMesh

func createGrid():
	createMesh(baseMesh)
	multimesh = MultiMesh.new()
	var pos := GetAllPosition(instanceCount)
	multimesh.transform_format = MultiMesh.TRANSFORM_3D
	multimesh.instance_count = instanceCount
	multimesh.mesh = meshInstance
	#multimesh.
	
	print("A_POSITIONS : " + str(pos.size()))
	var t:Transform3D = Transform3D(meshBasis, Vector3.ZERO)
	for i in multimesh.instance_count:
		if(i >= pos.size()):
			push_error("NOT ENOUGH SURFACE FOR THIS INSTANCE COUNT")
			return
		print("MULTIMESH SET AT POSITION : " + str(t))
		t = Transform3D(meshBasis, Vector3(pos[i].x,pos[i].y, 0))
		multimesh.set_instance_transform(i,t)
		


func GetAllPosition(count:int = 100) -> Array[Vector3]:
	var positions:Array[Vector3]
	var x = 0
	var y = 0
	
	positions.append(Vector3(x,y,0.0))
	
	for i in count:
		y += grid.y
		if(y >= surface.y):
			y = 0
			x += grid.x
			if(x >= surface.x):
				return positions
				
		positions.append(Vector3(x,y,0.0))
				
	return positions
