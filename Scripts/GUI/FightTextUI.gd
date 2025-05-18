class_name FightText
extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer

signal FightTextOut

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func StartFightText():
	animation_player.play("FightBegin")
	print("play anim")
	await  animation_player.animation_finished
	FightTextOut.emit()
