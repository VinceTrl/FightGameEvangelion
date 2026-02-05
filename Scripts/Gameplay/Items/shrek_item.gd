extends Node3D

@export var lifeTime: float = 10.0
@export var infinite = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(!infinite):
		await get_tree().create_timer(lifeTime,true,false,false).timeout
		queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
