class_name HealthComponent

extends Node

@export var healthPoints:int = 3
var isDead:bool = false

signal IncreaseHealth
signal ReduceHealth
signal Death

func ChangeHealth(amountToChange:int):
	var iniHealth := healthPoints
	
	healthPoints += amountToChange
	
	if(iniHealth > healthPoints):
		ReduceHealth.emit()
	elif(iniHealth < healthPoints):
		IncreaseHealth.emit()
		
	if(healthPoints <= 0):
		isDead = true
		Death.emit()
