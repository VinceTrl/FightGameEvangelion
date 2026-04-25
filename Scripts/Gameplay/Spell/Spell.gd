class_name Spell

extends Node3D

@export var lifeTime:float = 5.0
var lifeTimeTimer:SceneTreeTimer

func _process(delta: float) -> void:
	ProcessSpell(delta)

func CastSpell(duration:float = lifeTime):
	lifeTime = duration
	StartLifeTime()
	pass
	
func ProcessSpell(delta:float):
	pass
	
func StartLifeTime():
	lifeTimeTimer = get_tree().create_timer(lifeTime)
	await  lifeTimeTimer.timeout
	DestroySpell()
	
func DestroySpell():
	pass
