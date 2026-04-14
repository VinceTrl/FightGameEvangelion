class_name BlockManager

extends Node

var tick:float = 0.5

var blocks:Array[Block]

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
	BlockTicked.emit()
	BlockTick()
