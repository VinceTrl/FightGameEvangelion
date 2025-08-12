class_name OneWayCollision

extends StaticBody3D

@export var playerLayer_1: int = 7
@export var playerLayer_2: int = 8
@export var shapeSize: Vector3 = Vector3.ONE
var player1: PlayerCharacter
var player2: PlayerCharacter


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	call_deferred("GetPlayers")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	SetCollisionForPlayer(player1)
	SetCollisionForPlayer(player2)
	
	
	
func GetPlayers():
	for player in Manager.gameManager.players:
		if(player.playerID == 1):
			player1 = player
		if(player.playerID == 2):
			player2 = player
	
func SetCollisionForPlayer(_player:PlayerCharacter):
	if(!_player): return
	
	var maxY = global_position.y + (shapeSize.y / 2)
	var minY = global_position.y - (shapeSize.y / 2)
	var layerInt
	
	if(_player == player1):
		layerInt = playerLayer_1
	elif(_player == player2):
		layerInt = playerLayer_2
	
	if(_player.global_position.y <= maxY): #player under collision
		set_collision_layer_value(layerInt, false)
	elif(_player.global_position.y > maxY): #player above collision
		set_collision_layer_value(layerInt, true)
