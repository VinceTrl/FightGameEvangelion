extends Node

var player1:PlayerCharacter
var player2:PlayerCharacter

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var player1 := Manager.gameManager.GetPlayerFromIndex(1)
	var player2 := Manager.gameManager.GetPlayerFromIndex(2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player1_position := player1.global_position
	var player2_position := player2.global_position
	
	
