extends CharacterState

var deathDelay:float = 0.25
var timer:SceneTreeTimer
@export var audio:AudioStream

func EnterState():
	stateName = "Death"
	character.movement.currentDirection = Vector3.ZERO #stop movement
	character.animation.play("Hurt")
	character.DropItem()
	#queue_free()
	DeathDelay()
	
func ProcessState(delta: float):
	pass
	
func DeathDelay():
	await get_tree().create_timer(deathDelay).timeout
	GlobalSFX.EmitSound(audio,-10,character.global_position)
	character.queue_free()
