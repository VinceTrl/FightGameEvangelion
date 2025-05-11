extends Control

@onready var timer_text: Label = $TimerText

var gameManager: GameManager
var gameTimer

func _ready() -> void:
	gameManager = Manager.gameManager
	gameTimer = gameManager.game_timer

func _physics_process(delta):
	timer_text.text = time_to_minutes_secs_mili(gameTimer.time_left)

func time_to_minutes_secs_mili(time : float) -> StringName:
	var mins = int(time) / 60
	time -= mins * 60
	var secs = int(time)
	var mili = int((time - int(time)) * 100)
	return str("%0*d" % [2, mins]) + ":" + str("%0*d" % [2, secs]) + ":" + str("%0*d" % [2, mili]) 
