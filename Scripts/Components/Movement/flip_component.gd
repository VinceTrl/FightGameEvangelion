class_name FlipComponent

extends Node

@export var movement:MovementComponent
@export var flipNodes:Array[Node3D]
	
func ProcessFlip():
	var scaleX:float = 1
	
	if(movement.currentDirection.x > 0):
		scaleX = 1
	elif(movement.currentDirection.x < 0):
		scaleX = -1
		
	for node in flipNodes:
		node.scale.x = scaleX
