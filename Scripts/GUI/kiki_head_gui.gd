extends ControlShaker

@export var player_index:int = 1
var player:PlayerCharacter

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	player = Manager.gameManager.GetPlayerFromIndex(player_index)
	ConnectSignals()

func ConnectSignals():
	if(!player):return
	player.OnPlayerTakeDamage.connect(NodeShake)
