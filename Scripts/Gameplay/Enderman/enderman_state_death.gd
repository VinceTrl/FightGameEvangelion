extends CharacterState

var deathDelay:float = 0.25
var timer:SceneTreeTimer

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
	character.queue_free()
