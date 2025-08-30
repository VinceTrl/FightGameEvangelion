class_name OneWayCollision

extends StaticBody3D

@export var playerLayer_1: int = 7
@export var playerLayer_2: int = 8
@export var shapeSize: Vector3 = Vector3.ONE
var player1: PlayerCharacter
var player2: PlayerCharacter

var processCollision: bool = true


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
			
			
func ForceDrop(_playerToDrop:PlayerCharacter):
	var maxY = global_position.y + (shapeSize.y / 2)
	var minY = global_position.y - (shapeSize.y / 2)
	var layerInt
	
	if(_playerToDrop == player1):
		layerInt = playerLayer_1
	elif(_playerToDrop == player2):
		layerInt = playerLayer_2
		
	set_collision_layer_value(layerInt, false)
	processCollision = false
	print("DROP: start force drop on platform collision for player : ", _playerToDrop.name)
		
	var playerIsUnderCollision: bool = _playerToDrop.global_position.y <= minY
	var playerIsAboveCollision: bool = _playerToDrop.global_position.y > maxY
	var canReset := playerIsAboveCollision or playerIsUnderCollision
	
	await get_tree().create_timer(0.25,true,true,false).timeout
	
	while !canReset:
		await get_tree().process_frame
		
	print("DROP: Reset platform collision")
	set_collision_layer_value(layerInt, true)
	processCollision = true
	
func SetCollisionForPlayer(_player:PlayerCharacter):
	if(!processCollision):return
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
