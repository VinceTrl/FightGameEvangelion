extends Control

@onready var player_1: TextureRect = $CanvasLayer/Player1
@onready var player_2: TextureRect = $CanvasLayer/Player2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SetWinScreen(Manager.scoreManager.GetWinner())

func SetWinScreen(winnerID: int):
	if(winnerID == 0):
		player_1.visible = true
		player_2.visible = false
	else:
		player_1.visible = false
		player_2.visible = true
