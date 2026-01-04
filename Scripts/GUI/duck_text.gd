extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Manager.gameManager.OnFightStart.connect(DrawText)

func DrawText():
	animation_player.play("Intro")
	pass
