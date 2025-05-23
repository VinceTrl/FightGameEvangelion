extends Node3D


@export_range(0,10) var Multiplier:float;
const VU_COUNT = 7
const FREQ_MAX = 11050.0
const MIN_DB = 60

@export var lerp_smoothing:float = 8
var lerped_spectrum: Array[float] = []
var spectrum
var image_texture: ImageTexture
var image : Image

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lerped_spectrum.resize(VU_COUNT)
	image = Image.create(VU_COUNT,1,false, Image.FORMAT_RGBA8)
	for i in VU_COUNT:
		image.set_pixel(i,0, Color.BLACK)
	image_texture = ImageTexture.create_from_image(image)
	RenderingServer.global_shader_parameter_set("spectrum_texture", image_texture)
	spectrum = AudioServer.get_bus_effect_instance(1,0)
	

# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(delta: float) -> void:
	var prev_hz = 0
	#print ("------------------")
	for i in range(1, VU_COUNT+1):
		var hz = i * FREQ_MAX / VU_COUNT;
		var magnitude: float = spectrum.get_magnitude_for_frequency_range(prev_hz, hz).length()
		var energy = clamp((MIN_DB + linear_to_db(magnitude)) / MIN_DB, 0, 1)
		var effect = energy * Multiplier
		lerped_spectrum[i-1] = lerp(lerped_spectrum[i-1], effect, delta * lerp_smoothing)
		#print(i," : ",effect)
		image.set_pixel(i-1,0, Color.WHITE * effect)
		image.set_pixel(i-1,0, Color.WHITE * lerped_spectrum[i-1]) #Smoother effect
		prev_hz = hz
		
	image_texture.update(image)
		
