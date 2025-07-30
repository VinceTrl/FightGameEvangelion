class_name PhysicObject

extends RigidBody3D

@export var impulseForce = 0.625

@export_group("Hit effects setting")
@export var shakeCamOnHit = true
@export var shakeCamName = "HitShake"
@export var freezeOnHit = false
@export var glitchOnHit = false
@export_group("")

var moveDirection

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func TakeDamage(hitboxSource: Hitbox):
	if(hitboxSource == null): return
	
	print("HIT PHYSIC OBJECT")
	var nextDir = (global_position - hitboxSource.global_position).normalized()
	moveDirection = Vector3(nextDir.x,0,0)
	apply_impulse(nextDir * impulseForce)
	
	#Hit effects
	if(shakeCamOnHit):
		Manager.gameCamera.camShake.AskCamShake(shakeCamName)
		
	if(freezeOnHit):
		Manager.timeManager.freezeFrame(0.001,0.1)
		
	if(glitchOnHit):
		Manager.postProcessEffects.GlitchEffect()
	
	
	
