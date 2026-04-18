extends CharacterState

@export_custom(PROPERTY_HINT_LINK, "suffix:") var explosionScale:Vector3 = Vector3.ONE
const EXPLOSION = preload("uid://8mccoxd2fk3f")


func EnterState():
	stateName = "CREEPER EXPLODE"
	character.movement.currentDirection = Vector3.ZERO #stop movement
	character.ChangeState(stateMachine.Death)
	SpawnExplosion()
	pass
	
func ExitState():
	pass
	
func ProcessState(delta: float):
	pass
	
func PhysicsProcessState(delta: float):
	pass
	
func SpawnExplosion():
	var explosionScene = EXPLOSION.instantiate()
	get_tree().current_scene.add_child(explosionScene)
	explosionScene.scale = explosionScale
	explosionScene.global_position = character.global_position
	
