extends Spell

@onready var animation_player: AnimationPlayer = $Visual/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func CastSpell(duration:float = lifeTime,target:Node3D = null):
	super(duration,target)
	animation_player.play("ScaleIn")
	
func DestroySpell():
	queue_free()
	pass
