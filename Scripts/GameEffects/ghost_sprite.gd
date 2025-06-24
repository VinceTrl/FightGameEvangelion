extends Sprite3D

@export var lifeTime:float = 0.25
	
func _ready() -> void:
	_apply_texture()
	texture_changed.connect(_apply_texture)

func SetGhostSprite(sourceSprite: Sprite3D,ghostLifeTime: float = lifeTime):
	texture = sourceSprite.texture
	hframes = sourceSprite.hframes
	vframes = sourceSprite.vframes
	frame = sourceSprite.frame
	flip_h = sourceSprite.flip_h
	flip_v = sourceSprite.flip_v
	
	#global_position = sourceSprite.global_position
	lifeTime = ghostLifeTime
	FadeOutSprite(self,lifeTime)
	print("GHOST CREATED")
	
func FadeOutSprite(sprite: Sprite3D, duration: float = 1.0) -> void:
	var start_alpha: float = sprite.modulate.a
	var time: float = 0.0
	
	while time < duration:
		var t: float = time / duration
		var new_alpha: float = lerp(start_alpha, 0.0, t)
		
		var mod_color: Color = sprite.modulate
		mod_color.a = new_alpha
		sprite.modulate = mod_color
		_apply_alpha(new_alpha)

		await get_tree().process_frame
		time += get_process_delta_time()

	# Forcer alpha à 0 à la fin
	var final_color: Color = sprite.modulate
	final_color.a = 0.0
	sprite.modulate = final_color
	queue_free()
	
	
func _apply_texture():
	var shader_material : ShaderMaterial = material_override
	shader_material.set_shader_parameter("sprite_texture", texture)
	
func _apply_alpha(alpha):
	var shader_material : ShaderMaterial = material_override
	shader_material.set_shader_parameter("alpha", alpha * 0.05)
