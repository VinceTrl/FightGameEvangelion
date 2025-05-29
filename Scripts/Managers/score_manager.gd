class_name ScoreManager

extends Node

#FIGHT
@export var roundToWin = 2

var playerWinCount_1 = 0 #player 1
var playerWinCount_2 = 0 #player 2

var currentRound = 0

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
	currentRound += 1

func FinishFightRound():
	var player = Manager.gameManager.GetWinner()
	
	if (player == null): return
	
	if(player.playerID == 1):
		playerWinCount_1 += 1
	else:
		playerWinCount_2 += 1
		
	print("ROUND P1 : " + str(playerWinCount_1))
	print("ROUND P2 : " + str(playerWinCount_2))
