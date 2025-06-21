extends Node3D

@export var healthPoints:int = 3
@export var canTakeDamage:bool = true

@onready var node_shaker: NodeShaker = $NodeShaker

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func TakeDamage(hitboxSource: Hitbox):
	if(!canTakeDamage):return
	#hitboxSource.DealDamage()
	ChangeHealth(-hitboxSource.damage)
	
func ChangeHealth(healthAmount:int = -1):
	node_shaker.NodeShake()
	healthPoints += healthAmount
	if(healthPoints <= 0):
		Manager.gameManager.shitpost_gui.ShowRandomImage()
		queue_free()
