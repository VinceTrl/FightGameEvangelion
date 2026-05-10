class_name BlockManager

extends Node

var tick:float = 0.5

var blocks:Array[Block]

var currentTickIndex:int = 0
var maxTickIndex:int = 3

var clampPositionX:float = 6
var clampPositionY:float = 4.5


var spawnedBlocksPositions:Array[Vector3]

signal BlockTicked

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	BlockTick()
	pass # Replace with function body.
	
	
func RegisterBlock(block:Block):
	if(!block):return
	if(blocks.has(block)):return
	blocks.append(block)
	pass

func BlockTick():
	await get_tree().create_timer(tick).timeout
	UpdateTickIndex()
	BlockTicked.emit()
	BlockTick()
	
func UpdateTickIndex():
	currentTickIndex += 1
	if(currentTickIndex > maxTickIndex): currentTickIndex = 0
	pass
	
func RequestBlockSpawn(requestedPosition:Vector3) -> bool:
	if(spawnedBlocksPositions.has(requestedPosition)):
		return false
	else:
		if(CheckPositionInRange(requestedPosition)):
			spawnedBlocksPositions.append(requestedPosition)
			return true
		else:
			return false

func CheckPositionInRange(pos:Vector3):
	if (pos.x >= -clampPositionX and pos.x <= clampPositionX):
		if (pos.y >= -clampPositionY and pos.y <= clampPositionY):
			return true
		else:
			return false
	else:
		return false
