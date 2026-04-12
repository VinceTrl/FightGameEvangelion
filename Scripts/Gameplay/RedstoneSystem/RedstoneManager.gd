class_name RedstoneManager

extends Node

var tick:float = 0.25

var redstones:Array[RedstoneLink]

signal RedstoneUpdate

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	RedstoneTick()
	pass # Replace with function body.
	
	
func RegisterRedstone(redstone:RedstoneLink):
	if(!redstone):return
	if(redstones.has(redstone)):return
	redstones.append(redstone)
	pass

func RedstoneTick():
	await get_tree().create_timer(tick).timeout
	RedstoneUpdate.emit()
	RedstoneTick()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
