extends Spell

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func CastSpell(duration:float = lifeTime,target:Node3D = null):
	super(duration,target)
	animation_player.play("FadeIn")
	

func DestroySpell():
	super()
	animation_player.play("FadeOut")
	await animation_player.animation_finished
	queue_free()
