extends RedstoneReceiver

@export var mesh: MeshInstance3D

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

func _ready() -> void:
	super()
	call_deferred("InitVisual")
		
func InitVisual():
	material = mesh.get_surface_override_material(0).duplicate()
	mesh.set_surface_override_material(0,material)
	
	if(redstoneLink.isActive):
		mesh.visible = true
		UpdateMaterialEmission()
		UpdateMaterialTexture()
	else:
		mesh.visible = false

func OnTurnedOn():
	UpdateMaterialEmission()
	UpdateMaterialTexture()
	pass
	
func OnTurnedOff():
	UpdateMaterialEmission()
	UpdateMaterialTexture()
	pass
	
func UpdateMaterialEmission():
	if(redstoneLink.isPowerOn):
		material.emission_energy_multiplier = onEnergyMultiplier
		material.albedo_color = onAlbedo
	else:
		material.emission_energy_multiplier = offEnergyMultiplier
		material.albedo_color = offAlbedo
	
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
	pass
