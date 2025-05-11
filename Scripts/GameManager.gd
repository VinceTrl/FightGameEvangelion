class_name GameManager

extends Node

@onready var timeManager: TimeManager = $TimeManager
@onready var game_timer: Timer = $GameTimer
@export var fightDuration: float = 90.00

func _ready() -> void:
	
	#Register
	Manager.gameManager = self
	Manager.timeManager = timeManager
	game_timer.start(fightDuration)
