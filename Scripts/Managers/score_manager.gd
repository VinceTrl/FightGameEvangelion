class_name ScoreManager

extends Node

#FIGHT
@export var roundToWin = 2

var playerWinCount_1 = 0 #player 1
var playerWinCount_2 = 0 #player 2

var currentRound = 0
var fightIsFinished = false

signal onScoreUpdated

func _ready() -> void:
	Manager.OnGameStateChanged.connect(OnGameStateChanged)
	
func OnGameStateChanged(_state: GameStates.GameState):
	#fight begin
	if(_state == GameStates.GameState.FightIntro):
		StartFightRound()
		
	#fight end
	if(_state == GameStates.GameState.FightOutro):
		FinishFightRound()

func StartFightRound():
	print("start ROUND P1 : " + str(playerWinCount_1))
	print("start ROUND P2 : " + str(playerWinCount_2))
	
	#check the end of the Fight
	if(playerWinCount_1 >= roundToWin) or (playerWinCount_2 >= roundToWin):
		ResetScore()
		
	currentRound += 1

func FinishFightRound():
	var player = Manager.gameManager.GetWinner()
	
	print("WINNER: " + str(player))
	
	if (player == null): return
	
	if(player.playerID == 1):
		playerWinCount_1 += 1
	else:
		playerWinCount_2 += 1
		
	print("END ROUND P1 : " + str(playerWinCount_1))
	print("END ROUND P2 : " + str(playerWinCount_2))
	
	emit_signal("onScoreUpdated")
	
	#check the end of the Fight
	if(playerWinCount_1 >= roundToWin):
		FinishFight()
	elif(playerWinCount_2 >= roundToWin):
		FinishFight()
	
func FinishFight():
	fightIsFinished = true
	
func ResetScore():
	playerWinCount_1 = 0
	playerWinCount_2 = 0
	currentRound = 0
	fightIsFinished = false
	emit_signal("onScoreUpdated")
