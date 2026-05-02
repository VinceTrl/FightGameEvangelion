extends Node3D

@onready var background_quad: MeshInstance3D = $BackgroundQuad

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	call_deferred("ConnectSignals")
	#background_quad.visible = false
	visible = false
	
	
func ConnectSignals():
	Manager.replayManager.ReplayFinished.connect(ShowBackground)
	Manager.gameManager.FightEnd.connect(ShowBackground)

func ShowBackground():
	#background_quad.visible = true
	visible = true
