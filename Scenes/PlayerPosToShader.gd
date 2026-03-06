extends ColorRect

var player1:PlayerCharacter
var player2:PlayerCharacter

func _process(delta: float) -> void:
	
	var player1 := Manager.gameManager.GetPlayerFromIndex(1)
	var player2 := Manager.gameManager.GetPlayerFromIndex(2)
	if(!player1):return
	if(!player2):return
	var player1_position := player1.global_position
	var player2_position := player2.global_position
	
	
	self.material.set_shader_parameter("Player1Pos",player1_position)
	self.material.set_shader_parameter("Player2Pos",player2_position)
