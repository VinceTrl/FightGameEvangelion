extends RedstoneReceiver

@export var block:Block
@export var explosionDelay:float = 0.25

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	pass # Replace with function body.

func OnTurnedOn():
	await get_tree().create_timer(explosionDelay).timeout
	block.ChangeHealth(-block.healthPoints)
	
	
