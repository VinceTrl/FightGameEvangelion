extends Resource
class_name SpawnableItem

@export var itemName: StringName = "EXPLOSION"
@export var scenePath: StringName = "res://Scenes/Gameplay/heart.tscn"
@export var spawnOnGround = false
@export var groundOffset: Vector3
@export var spawnOncePerGame: bool = false
@export var isUniqueInstance: bool = false
@export var spawnChance: int = 1
var resource
