class_name VFXOneShot

extends Node3D

var particles: Array[GPUParticles3D] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if(child is GPUParticles3D):
			child as GPUParticles3D
			particles.append(child)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func EmitAllParticles():
	for particle in particles:
		particle.emitting = true
