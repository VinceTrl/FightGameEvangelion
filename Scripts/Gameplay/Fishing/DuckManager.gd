extends Node

@export var duckSpawnNodes:Array[Node3D]
@export var ducks:Array[Node3D]
const DUCK = preload("res://Scenes/Gameplay/duck.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for duck in ducks:
		ConnectDuck(duck)
	
func SpawnDuck():
	print("SPAWN DUCK")
	var duck = DUCK.instantiate()
	add_child(duck)
	var spawnNode:Node3D = duckSpawnNodes.pick_random()
	duck.global_position = spawnNode.global_position
	ConnectDuck(duck)
	
func ConnectDuck(duck:Node3D):
	duck.DuckDestroyed.connect(SpawnDuck)
