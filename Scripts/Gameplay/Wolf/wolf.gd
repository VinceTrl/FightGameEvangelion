class_name Wolf

extends Character

@export var angryStateDuration:float = 15.0
@export var noHurtStates:Array[CharacterState]

@export_group("Visual")
@export var angryMaterial:Material
@export var normalMaterial:Material
@export var meshes:Array[MeshInstance3D]

var lastHitbox:Hitbox
var isAngry:bool = false
var chaseTarget:Node3D

func _ready() -> void:
	super()
	previousState = stateMachine.Idle
	currentState = stateMachine.Idle
	stateMachine.currentState = currentState
	ChangeState(stateMachine.Idle)
	
	
func TakeDamage(hitbox:Hitbox):
	for state in noHurtStates:
		if(state == currentState):
			return
			
	if(currentState != stateMachine.Hurt and currentState != stateMachine.Death):
		lastHitbox = hitbox
		ChangeState(stateMachine.Hurt)
		
func StartAngryState(target:Node3D):
	chaseTarget = target
	isAngry = true
	ChangeMeshMaterial(angryMaterial)
	await get_tree().create_timer(angryStateDuration).timeout
	StopAngryState()
	
	
func StopAngryState():
	isAngry = false
	ChangeMeshMaterial(normalMaterial)
	
func ReceiveHowl():
	StartAngryState(null)
	ChangeState(stateMachine.DashAttack)
	pass
	
func GetTargetDirection() ->Vector3:
	return (chaseTarget.global_position - global_position).normalized()
	
func ChangeMeshMaterial(material:Material):
	for mesh in meshes:
		OverrideSurface(mesh,material)
	
func OverrideSurface(meshInstance:MeshInstance3D,newMat:Material):
	for surface in meshInstance.mesh.get_surface_count():
		meshInstance.set_surface_override_material(surface,newMat)
	pass
