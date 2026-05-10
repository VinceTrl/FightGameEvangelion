extends RedstoneReceiver

@export var isInvisible:bool = false

@export_group("mesh references")
@export var mesh: MeshInstance3D
@export var topLine:MeshInstance3D
@export var bottomLine:MeshInstance3D
@export var rightLine:MeshInstance3D
@export var leftLine:MeshInstance3D

@export_group("materials settings")
@export_range(0.0,16.0,0.1) var onEnergyMultiplier:float = 1.0
@export_range(0.0,16.0,0.1) var offEnergyMultiplier:float = 0.0
@export var onAlbedo:Color = Color.RED
@export var offAlbedo:Color = Color.DIM_GRAY

@export var NoLinkTexture:Texture2D
@export var LinkTexture:Texture2D

@export var horizontalRot:Vector3 = Vector3(-90,0,0)
@export var verticalRot:Vector3 = Vector3(90,90,90)

var material:Material
var heightAlignmentThreshold:float = 0.1
var materials:Array[Material]

func _ready() -> void:
	super()
	if(isInvisible):
		queue_free()
		return
	call_deferred("InitVisual")
		
func InitVisual():
	InitMaterial(topLine)
	InitMaterial(bottomLine)
	InitMaterial(rightLine)
	InitMaterial(leftLine)
	
	if(redstoneLink.isActive):
		#mesh.visible = true
		UpdateMaterialEmission()
		UpdateMeshes()
		#UpdateMaterialTexture()
	else:
		SetMeshesVisibility(false)
		mesh.visible = false
		
func InitMaterial(meshInstance:MeshInstance3D):
	var mat = meshInstance.get_surface_override_material(0).duplicate()
	meshInstance.set_surface_override_material(0,mat)
	materials.append(mat)
		
func SetMeshesVisibility(isVisible:bool):
	topLine.visible = isVisible
	bottomLine.visible = isVisible
	leftLine.visible = isVisible
	rightLine.visible = isVisible
	
	
func UpdateMeshes():
	topLine.visible = false
	bottomLine.visible = false
	rightLine.visible = false
	leftLine.visible = false
	
	var links := redstoneLink.GetConnectedRedstoneLinks()
	
	for link in links:
		#if up or down
		if(link.isActive):
			var heightDiff:float = abs(link.global_position.y - redstoneLink.global_position.y)
			if(heightDiff > heightAlignmentThreshold):
				if(link.global_position.y > redstoneLink.global_position.y):
					topLine.visible = true
				else:
					bottomLine.visible = true
			else: # if right or left
				if(link.global_position.x > redstoneLink.global_position.x):
					rightLine.visible = true
				else:
					leftLine.visible = true
	pass

func OnTurnedOn():
	UpdateMaterialEmission()
	#UpdateMaterialTexture()
	pass
	
func OnTurnedOff():
	UpdateMaterialEmission()
	#UpdateMaterialTexture()
	pass
	
func OnUpdated():
	UpdateMeshes()
	pass
	
func UpdateMaterialEmission():
	
	var color := offAlbedo
	var energy := offEnergyMultiplier
	
	if(redstoneLink.isPowerOn):
		energy = onEnergyMultiplier
		color = onAlbedo
		
		
	for mat in materials:
		mat.emission_energy_multiplier = energy
		mat.albedo_color = color
	
#OLD FUNCTION >>> NOT USED
func UpdateMaterialTexture():
	if(redstoneLink.redstoneSource):
		material.albedo_texture = LinkTexture
		material.emission_texture = LinkTexture
		
		if(redstoneLink.global_position.y != redstoneLink.redstoneSource.global_position.y):
			mesh.rotation_degrees = verticalRot
		else:
			mesh.rotation_degrees = horizontalRot
	else:
		material.albedo_texture = NoLinkTexture
		material.emission_texture = NoLinkTexture
