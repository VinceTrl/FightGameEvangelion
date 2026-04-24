class_name FlipComponent

extends Node

@export var movement:MovementComponent
@export var flipNodes:Array[Node3D]
var currentScale:float = 1
	
func ProcessFlip():
	var scaleX:float
	
	if(movement.currentDirection.x > 0):
		scaleX = 1
	elif(movement.currentDirection.x < 0):
		scaleX = -1
	else:
		scaleX = currentScale
		
	currentScale = scaleX
		
	for node in flipNodes:
		node.scale.x = scaleX
		
func IsFacingRight() -> bool:
	return currentScale > 0
	
func ResetFlip():
	currentScale = 1
	for node in flipNodes:
		node.scale.x = 1
