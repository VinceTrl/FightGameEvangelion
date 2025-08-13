class_name GameDebug

extends Node

@export_group("MAP DEBUG")
##if true : force the game to spawn a specific map with the index below
@export var debugMap: bool = false
##index of the map environment to spawn (0 for Evangelion, 1 for test map)
@export var mapIndex: int = 0

##if true : force the game to spawn a specific stage with the index below
@export var debugStage: bool = false
##index of the stage level to spawn (!! stages are linked to a map, it means that stage 0 in map 0 isn't the same as stage 0 in map 1 !!)
@export var stageIndex: int = 0
@export_group("")

@export_group("PLAYER DEBUG")
@export var debugPlayer: bool = false
@export var playerDebugID:Array[int]
@export var debugPlayerHitboxes: bool = false
@export_group("")

@export_group("CAMERA DEBUG")
@export var debugCamera: bool = false
@export_group("")

@export_group("BEYBLADE DEBUG")
@export var debugBeyblade: bool = false
@export var debugBeybladeHitbox: bool = false
@export_group("")

@export_group("HITBOX DEBUG")
@export var debugHitboxShape: bool = false
@export var debugHitboxText: bool = false
@export var debugActiveColor: Color = Color.LIME_GREEN
@export var debugInactiveColor: Color = Color.RED
@export var debugActiveLineThickness: float = 0.1
@export var debugInactiveLineThickness: float = 0.01
@export_group("")
