class_name TitleScreen
extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var post_process: PostProcess = $PostProcess
const TITLE_SCREEN_POSTPROCESS = preload("res://Resources/PostProcessConfig/title_screen_postprocess.tres")

signal OnTitleScreenReady
signal titleScreenExit

func _ready() -> void:
	Manager.titleScreen = self
	emit_signal("OnTitleScreenReady")
	
	
func ResetTitleScreen():
	animation_player.play("RESET")
	post_process.configuration.CRT = true

func SetTitleScreenVisibility(isVisible: bool):
	visible = isVisible

func AcceptTitleScreen():
	animation_player.play("TitleExit")
	audio_stream_player.play()
	await  animation_player.animation_finished
	post_process.configuration.CRT = false
	titleScreenExit.emit()
	SetTitleScreenVisibility(false)
