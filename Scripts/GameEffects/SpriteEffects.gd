@tool
extends Sprite3D

#sprite color variables
@export var hitColor: Color = Color.CRIMSON
@export var hitColorTime: float = 0.1
var initialColor: Color

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initialColor = modulate
	
	#To 
	if not material_override:
		_apply_material_override()
	
	_apply_texture()
	texture_changed.connect(_apply_texture)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func HitColorEffect():
	var timer = get_tree().create_timer(hitColorTime,true,false,true)
	modulate = hitColor
	await timer.timeout
	modulate = initialColor

func _apply_material_override():
	var shader_material = ShaderMaterial.new()
	shader_material.shader = load("res://Assets/Shaders/KikiFighter_shader.gdshader")
	material_override = shader_material
	
func _apply_texture():
	var shader_material : ShaderMaterial = material_override
	shader_material.set_shader_parameter("sprite_texture", texture)
