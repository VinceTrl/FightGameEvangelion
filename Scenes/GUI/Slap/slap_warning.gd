extends Node3D


const SLAP_TARGET = preload("res://Scenes/GUI/Slap/slap_target.tscn")

@export var line_length: float = 10.0
@export var object_count: int = 10
@export var spawn_delay: float = 0.5
@export var startFromRight:bool = true
@export_enum("LeftToRight", "RightToLeft") var spawn_direction: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SpawnAlongLine()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func SpawnAlongLine() -> void:
	if object_count <= 0:
		return

	var start_x = -line_length / 2.0
	var spacing = line_length / max(object_count - 1, 1)

	for i in object_count:
		var index = i if spawn_direction == 0 else (object_count - 1 - i)
		var x_pos = start_x + index * spacing
		SpawnWithDelay(Vector3(x_pos, 0,0), i * spawn_delay)

func SpawnWithDelay(position: Vector3, delay: float) -> void:
	await get_tree().create_timer(delay).timeout
	var instance = SLAP_TARGET.instantiate()
	
	if instance != null:
		instance.position = position
		add_child(instance)
