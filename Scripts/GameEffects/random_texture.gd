extends MeshInstance3D

@export var textures:Array[Texture]
@export var material:StandardMaterial3D

func SetRandomTextureOnMaterial():
	material.albedo_texture = textures.pick_random()
