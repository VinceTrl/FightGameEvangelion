extends Resource
class_name GlitchParameters

@export var glitchName: StringName = "Default"

@export var glitchEffectTime = 1.0
@export var glitchAnimationCurve: Curve

@export_group("Glitch target params")
@export_range(0.0, 0.1, 0.005) var GlitchRange = 0.05
@export_range(0.0, 300, 0.1) var GlitchNoiseQuality = 250.0
@export_range(-0.6, 0.6, 0.0010) var GlitchIntenity = 0.0088
@export_range(-0.1, 0.1, 0.001) var GlitchOffset = 0.03
@export_range(0.0, 5.0, 0.001) var GlitchColorOffset = 1.3
