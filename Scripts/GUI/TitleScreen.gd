class_name TitleScreen
extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

signal OnTitleScreenReady
signal titleScreenExit

func _ready() -> void:
	Manager.titleScreen = self
	emit_signal("OnTitleScreenReady")
	
	
func ResetTitleScreen():
	animation_player.play("RESET")

func SetTitleScreenVisibility(isVisible: bool):
	visible = isVisible

func AcceptTitleScreen():
	animation_player.play("TitleExit")
	audio_stream_player.play()
	await  animation_player.animation_finished
	titleScreenExit.emit()
	SetTitleScreenVisibility(false)
