class_name PlayerSpawn
extends Node3D

@export var playerID:int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Manager.gameManager.RegisterPlayerSpawn(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
