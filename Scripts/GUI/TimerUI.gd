extends Control

@onready var timer_text: Label = $TimerText
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var timeWarningThreshold:float = 15.0
var inWarning := false
var timerStarted := false

var gameManager: GameManager
var gameTimer

func _ready() -> void:
	gameManager = Manager.gameManager
	gameTimer = gameManager.game_timer
	gameManager.OnFightStart.connect(TimerStart)

func _physics_process(delta):
	if(!timerStarted):return
	timer_text.text = time_to_minutes_secs_mili(gameTimer.time_left)
	Warning()
	TimeOut()
	
func TimerStart():
	timerStarted = true
	
func Warning():
	if(!timerStarted):return
	if(inWarning):return
	if(gameTimer.time_left <= timeWarningThreshold):
		inWarning = true
		animation_player.play("Warning")
		print("Set Timer in warning")
	
func TimeOut():
	if(!timerStarted):return
	if(gameTimer.time_left <= 0.0):
		animation_player.play("TimeOut")
		print("Set Timer in Time Out ")
	

func time_to_minutes_secs_mili(time : float) -> StringName:
	var mins = int(time) / 60
	time -= mins * 60
	var secs = int(time)
	var mili = int((time - int(time)) * 100)
	return str("%0*d" % [2, mins]) + ":" + str("%0*d" % [2, secs]) + ":" + str("%0*d" % [2, mili]) 
