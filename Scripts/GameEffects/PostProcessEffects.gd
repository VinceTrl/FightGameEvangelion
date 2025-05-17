class_name  PostProcessEffects
extends Node

@onready var gameplay_post_process: PostProcess = $GameplayPostProcess
@onready var speed_lines_timer: Timer = $Timers/SpeedLinesTimer
@onready var chromatic_aberration_timer: Timer = $Timers/ChromaticAberrationTimer
@onready var grain_timer: Timer = $Timers/GrainTimer
@onready var storm_timer: Timer = $Timers/StormTimer
@onready var glitch_timer: Timer = $Timers/GlitchTimer

@export_category("ANIMATION")
@export_group("SPEED LINES")
@export var speedLinesEffectTime = 2.0
@export var speedLinesAnimationCurve: Curve
var inAnimSpeedLines = false

var init_speedLinesDensity
var init_speedLinesCount
var init_speedLinesSpeed
var init_speedLinesColor

@export_group("CHROMATIC ABERRATION")
@export var chromaticAberrationEffectTime = 2.0
@export var chromaticAberrationAnimationCurve: Curve
var inAnimChromaticAberration = false

var init_chromaticAberrationStrenght

@export_group("GRAIN")
@export var grainEffectTime = 2.0
@export var grainAnimationCurve: Curve
var inAnimGrain = false

var init_grainPower

@export_group("PARTICLE STORM")
@export var stormEffectTime = 1.0
@export var stormAnimationCurve: Curve
var inAnimStorm = false

var init_stormColor
var init_stormDensity
var init_stormDirection
var init_stormSpeed

@export_group("GLITCH")
@export var glitchEffectTime = 1.0
@export var glitchAnimationCurve: Curve
var inAnimGlitch = false
@export var glitchParams: GlitchParameters

var init_glitchIntensity
var init_glitchOffset
var init_glitchColorOffset

@export_category("POST PROCESS TARGET VALUES")
@export var targetConfig: PostProcessingConfiguration

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	Manager.postProcessEffects = self
	
	#SPEED LINES
	init_speedLinesDensity = gameplay_post_process.configuration.SpeedLineDensity
	init_speedLinesCount = gameplay_post_process.configuration.SpeedLinesCount
	init_speedLinesSpeed = gameplay_post_process.configuration.SpeedLineSpeed
	init_speedLinesColor = gameplay_post_process.configuration.SpeedLinesColor
	
	#Chromatic Aberration
	init_chromaticAberrationStrenght = gameplay_post_process.configuration.StrenghtCA
	
	#Grain
	init_grainPower = gameplay_post_process.configuration.GrainPower
	
	#particles Storm
	init_stormColor = gameplay_post_process.configuration.particle_storm_color
	init_stormDensity = gameplay_post_process.configuration.particle_storm_density
	init_stormDirection = gameplay_post_process.configuration.particle_storm_wind_direction
	init_stormSpeed = gameplay_post_process.configuration.particle_storm_wind_speed
	
	#Glitch
	init_glitchIntensity = gameplay_post_process.configuration.GlitchIntenity
	init_glitchOffset = gameplay_post_process.configuration.GlitchOffset
	init_glitchColorOffset = gameplay_post_process.configuration.GlitchColorOffset
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	DebugPostProcess()
	
	
func DebugPostProcess() -> void:
	if(Input.is_action_just_pressed("DebugKey")):
		#SpeedLineEffect()
		#ChromaticAberrationEffect()
		#GrainEffect()
		GlitchEffect()
	
	
# SPEED LINES
func SpeedLineEffect():
	
	#Reset Anim if it's already animating
	if(inAnimSpeedLines):
		speed_lines_timer.stop()
		ResetSpeedLines()
		
	#Start animation
	inAnimSpeedLines = true
	speed_lines_timer.start(speedLinesEffectTime)
	
	#Animation frame update
	while speed_lines_timer.time_left > 0.0:
		var _timeProgress = speedLinesEffectTime - speed_lines_timer.time_left 
		var _ratio = _timeProgress/speedLinesEffectTime
		var _curveValue = speedLinesAnimationCurve.sample(_ratio)
		var _animValueDensity = lerp(init_speedLinesDensity,targetConfig.SpeedLineDensity,_curveValue)
		var _animValueSpeed = lerp(init_speedLinesSpeed,targetConfig.SpeedLineSpeed,_curveValue)
		var _animValueLinesCount = lerp(init_speedLinesCount,targetConfig.SpeedLinesCount,_curveValue)
		var _animValueColor = lerp(init_speedLinesColor,targetConfig.SpeedLinesColor,_curveValue)
		
		gameplay_post_process.configuration.SpeedLineDensity = _animValueDensity
		gameplay_post_process.configuration.SpeedLineSpeed = _animValueSpeed
		gameplay_post_process.configuration.SpeedLinesCount = _animValueLinesCount
		gameplay_post_process.configuration.SpeedLinesColor = _animValueColor
		
		await get_tree().process_frame
		
	ResetSpeedLines()
	
func ResetSpeedLines():
	inAnimSpeedLines = false
	gameplay_post_process.configuration.SpeedLineDensity = init_speedLinesDensity
	gameplay_post_process.configuration.SpeedLineSpeed = init_speedLinesSpeed
	gameplay_post_process.configuration.SpeedLinesCount = init_speedLinesCount
	gameplay_post_process.configuration.SpeedLinesColor = init_speedLinesColor
	
# CHROMATIC ABERRATION
func ChromaticAberrationEffect(_time: float = chromaticAberrationEffectTime, _timer: Timer = chromatic_aberration_timer):
	
	#Reset Anim if it's already animating
	if(inAnimChromaticAberration):
		_timer.stop()
		ResetChromaticAberration()
		
	#Start animation
	inAnimChromaticAberration = true
	_timer.start(_time)
	
	#Animation frame update
	while _timer.time_left > 0.0:
		var _timeProgress = _time - _timer.time_left 
		var _ratio = _timeProgress/_time
		var _curveValue = chromaticAberrationAnimationCurve.sample(_ratio)
		var _animValueStrenght = lerp(init_chromaticAberrationStrenght,targetConfig.StrenghtCA,_curveValue)
		
		gameplay_post_process.configuration.StrenghtCA = _animValueStrenght
		
		await get_tree().process_frame
		
	ResetChromaticAberration()
	
func ResetChromaticAberration():
	inAnimChromaticAberration = false
	gameplay_post_process.configuration.StrenghtCA = init_chromaticAberrationStrenght
	
	
# GRAIN
func GrainEffect(_time: float = grainEffectTime, _timer: Timer = grain_timer):
	
	#Reset Anim if it's already animating
	if(inAnimGrain):
		_timer.stop()
		ResetGrain()
		
	#Start animation
	inAnimGrain = true
	_timer.start(_time)
	
	#Animation frame update
	while _timer.time_left > 0.0:
		var _timeProgress = _time - _timer.time_left 
		var _ratio = _timeProgress/_time
		var _curveValue = grainAnimationCurve.sample(_ratio)
		var _animValuePower = lerp(init_grainPower,targetConfig.GrainPower,_curveValue)
		
		gameplay_post_process.configuration.GrainPower = _animValuePower
		
		await get_tree().process_frame
		
	ResetGrain()
	
func ResetGrain():
	inAnimGrain = false
	gameplay_post_process.configuration.GrainPower = init_grainPower
	
# PARTICLE STORM
func StormEffect(_dir: Vector2 = Vector2.ONE, _time: float = stormEffectTime, _timer: Timer = storm_timer):
	
	#Reset Anim if it's already animating
	if(inAnimStorm):
		_timer.stop()
		ResetStorm()
		
	#Start animation
	inAnimStorm = true
	_timer.start(_time)
	
	gameplay_post_process.configuration.particle_storm_wind_direction = _dir
	
	#Animation frame update
	while _timer.time_left > 0.0:
		var _timeProgress = _time - _timer.time_left 
		var _ratio = _timeProgress/_time
		var _curveValue = stormAnimationCurve.sample(_ratio)
		var _animValueColor= lerp(init_stormColor,targetConfig.particle_storm_color,_curveValue)
		var _animValueDensity= lerp(init_stormDensity,targetConfig.particle_storm_density,_curveValue)
		var _animValueSpeed= lerp(init_stormSpeed,targetConfig.particle_storm_wind_speed,_curveValue)
		
		gameplay_post_process.configuration.particle_storm_color = _animValueColor
		#gameplay_post_process.configuration.particle_storm_density = _animValueDensity
		gameplay_post_process.configuration.particle_storm_wind_speed = _animValueSpeed
		
		await get_tree().process_frame
		
	ResetStorm()
	
func ResetStorm():
	inAnimStorm = false
	gameplay_post_process.configuration.particle_storm_wind_direction = init_stormDirection
	
	gameplay_post_process.configuration.particle_storm_color = init_stormColor
	gameplay_post_process.configuration.particle_storm_density = init_stormDensity
	gameplay_post_process.configuration.particle_storm_wind_speed = init_stormSpeed
	
	
# GLITCH
func GlitchEffect(_params: GlitchParameters = glitchParams, _timer: Timer = glitch_timer):
	var _time = _params.glitchEffectTime
	
	#Reset Anim if it's already animating
	if(inAnimGlitch):
		_timer.stop()
		ResetGlitch()
		
	#Start animation
	inAnimGlitch = true
	_timer.start(_time)
	
	#Animation frame update
	while _timer.time_left > 0.0:
		var _timeProgress = _time - _timer.time_left 
		var _ratio = _timeProgress/_time
		var _curveValue = _params.glitchAnimationCurve.sample(_ratio)
		
		var _animValueIntensity = lerp(init_glitchIntensity,_params.GlitchIntenity,_curveValue)
		var _animValueOffset = lerp(init_glitchOffset,_params.GlitchOffset,_curveValue)
		var _animValueColorOffset = lerp(init_glitchColorOffset,_params.GlitchColorOffset,_curveValue)
		
		gameplay_post_process.configuration.GlitchIntenity = _animValueIntensity
		gameplay_post_process.configuration.GlitchOffset = _animValueOffset
		gameplay_post_process.configuration.GlitchColorOffset = _animValueColorOffset
		
		await get_tree().process_frame
		
	ResetGlitch()
	
func ResetGlitch():
	inAnimGlitch = false
	gameplay_post_process.configuration.GlitchIntenity = init_glitchIntensity
	gameplay_post_process.configuration.GlitchOffset = init_glitchOffset
	gameplay_post_process.configuration.GlitchColorOffset = init_glitchColorOffset
