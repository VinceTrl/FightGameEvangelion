extends Node3D

@onready var hand_rot: RotationToTarget = $Hand_rot
@onready var hand_move: MovementToTarget = $Hand_rot/hand_pointing



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	call_deferred("ConnectSignals")
	
	
func ConnectSignals():
	Manager.gameManager.eva.OnSlapStart.connect(OnSlapStart)
	Manager.gameManager.eva.OnSlapHitStart.connect(OnSlapEnd)
	print("FPHAND : CONNECTED TO SIGNALS")
	
	
func OnSlapStart():
	visible = true
	var target := Manager.gameManager.eva.target
	hand_rot.lookTarget = target
	hand_rot.rotateToTarget = true
	hand_move.moveTarget = target
	
func OnSlapEnd():
	visible = false
	hand_rot.rotateToTarget = false
	hand_rot.lookTarget = null
	hand_move.moveTarget = null


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
