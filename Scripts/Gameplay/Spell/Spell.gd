class_name Spell

extends Node3D

## -1 to infinite lifetime
var lifeTime:float = 5.0 
var lifeTimeTimer:SceneTreeTimer
var spellTarget:Node3D

func _process(delta: float) -> void:
	ProcessSpell(delta)

func CastSpell(duration:float = lifeTime,target:Node3D = null):
	lifeTime = duration
	spellTarget = target
	StartLifeTime()
	pass
	
func ProcessSpell(delta:float):
	pass
	
func StartLifeTime():
	if(lifeTime < 0.0):
		return
	lifeTimeTimer = get_tree().create_timer(lifeTime)
	await  lifeTimeTimer.timeout
	DestroySpell()
	
func DestroySpell():
	pass
