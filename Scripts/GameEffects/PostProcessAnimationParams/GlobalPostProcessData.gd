extends Node

const GAMEPLAY_POST_PROCESS_CONFIG = preload("res://Resources/PostProcessConfig/gameplay_post_process_config.tres")
var gameplay_post_process: PostProcessingConfiguration

@export_category("ANIMATION")
var init_speedLinesDensity
var init_speedLinesCount
var init_speedLinesSpeed
var init_speedLinesColor

@export_group("CHROMATIC ABERRATION")
var init_chromaticAberrationStrenght

@export_group("GRAIN")
var init_grainPower

@export_group("PARTICLE STORM")
var init_stormColor
var init_stormDensity
var init_stormDirection
var init_stormSpeed

@export_group("GLITCH")
var init_glitchIntensity
var init_glitchOffset
var init_glitchColorOffset

@export_group("PIXEL")
var init_Pixelate

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GetConfig()
	GetValues()
	
	
func GetConfig():
	GAMEPLAY_POST_PROCESS_CONFIG as PostProcessingConfiguration
	gameplay_post_process = GAMEPLAY_POST_PROCESS_CONFIG
	#gameplay_post_process.duplicate()
	#PostProcessingConfiguration.new()

func GetValues():

	#SPEED LINES
	init_speedLinesDensity = gameplay_post_process.SpeedLineDensity
	init_speedLinesCount = gameplay_post_process.SpeedLinesCount
	init_speedLinesSpeed = gameplay_post_process.SpeedLineSpeed
	init_speedLinesColor = gameplay_post_process.SpeedLinesColor
	
	#Chromatic Aberration
	init_chromaticAberrationStrenght = gameplay_post_process.StrenghtCA
	
	#Grain
	init_grainPower = gameplay_post_process.GrainPower
	
	#particles Storm
	init_stormColor = gameplay_post_process.particle_storm_color
	init_stormDensity = gameplay_post_process.particle_storm_density
	init_stormDirection = gameplay_post_process.particle_storm_wind_direction
	init_stormSpeed = gameplay_post_process.particle_storm_wind_speed
	
	#Glitch
	init_glitchIntensity = gameplay_post_process.GlitchIntenity
	init_glitchOffset = gameplay_post_process.GlitchOffset
	init_glitchColorOffset = gameplay_post_process.GlitchColorOffset

	
	#pixelate
	init_Pixelate = gameplay_post_process.PixelatePixelSize
	
	print("PP DATA : INIT VALUES")
