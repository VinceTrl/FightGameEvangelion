class_name GameStateManager
extends Node

var previousState : GameStates
var currentState : GameStates
@onready var title_screen: GameStates = $TitleScreen

signal OnTitleScreenStart

func _process(delta: float) -> void:
	currentState.Update(delta)
