extends Spell

@export var animation:AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func CastSpell(duration:float = lifeTime,target:Node3D = null):
	if(Manager.gameCamera.camera_roll.isRolling):
		queue_free()
		return
	super(duration,target)
	animation.play("SpellSpawn")
	Manager.gameCamera.camera_roll.RollCamera()
	await animation.animation_finished
	animation.play("SpellIdle")
	
func DestroySpell():
	Manager.gameCamera.camera_roll.ResetRoll()
	queue_free()
	pass
