class_name ParticlesHolder

extends Node3D

@export var particles:Array[GPUParticles3D]
@export var startEmitting:bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(startEmitting):
		EmitParticles()
	else:
		StopParticles()

func EmitParticles():
	for particle in particles:
		particle.emitting = true
	
func StopParticles():
	for particle in particles:
		particle.emitting = false
	
