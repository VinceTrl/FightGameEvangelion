class_name ResultScreen
extends Control

@onready var win_text: Label = $ColorRect/WinText
@onready var score_text: Label = $ScoreText
@export var displayDelay: float = 1.0
@export var scoreUpdateDelay: float = 0.75
@export var playerColor1:Color
@export var playerColor2:Color

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var node = self
	#if(node is Control):
		#node as Control
		#var childrens = get_all_descendants(node)
		#
		#for child in childrens:
			#if(child is Label):
				#win_text = child
				##print("text found")
		
	node.visible = false
	Manager.gameStateManager.OnResultScreenEnd.connect(ExitResult)
	SetScoreText()
	
func get_all_descendants(node: Node) -> Array:
	var result: Array = []
	for child in node.get_children():
		result.append(child)
		result += get_all_descendants(child)
	return result

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func StartResult():
	
	var player = Manager.gameManager.GetWinner()
	var winnerText
	
	if(player.playerID == 1):
		score_text.label_settings.font_color = playerColor1
	else:
		score_text.label_settings.font_color = playerColor2
	
	
	if(player == null):
		winnerText = "DOUBLE KO"
	else:
		winnerText = "Player" + str(player.playerID)
		win_text.text = winnerText + " Wins"
		
	await get_tree().create_timer(displayDelay,true,false,false).timeout
		
	self.visible = true	
	
	await get_tree().create_timer(scoreUpdateDelay,true,false,false).timeout
	
	SetScoreText()
		
	self.visible = true
	
func SetScoreText():
	
	var player1Score = Manager.scoreManager.playerWinCount_1
	var player2Score = Manager.scoreManager.playerWinCount_2
	var scoreString = str(player1Score) + " - " + str(player2Score)
		
	score_text.text = scoreString
	
func ExitResult():
	visible = false
