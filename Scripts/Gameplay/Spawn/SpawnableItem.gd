extends Resource
class_name SpawnableItem

@export var itemName: StringName = "EXPLOSION"
@export var scenePath: StringName = "res://Scenes/Gameplay/explosion.tscn"
@export var spawnOnGround = false
@export var groundOffset: Vector3
var resource
