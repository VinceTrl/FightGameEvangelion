extends Node3D

@onready var animated_sprite_3d: AnimatedSprite3D = $Visual/AnimatedSprite3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite_3d.animation_finished.connect(DestroyNode)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func DestroyNode():
	queue_free()
