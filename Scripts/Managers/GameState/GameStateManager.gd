class_name GameStateManager
extends Node

var previousState : GameStates
var currentState : GameStates
@onready var title_screen: GameStates = $TitleScreen

signal OnTitleScreenStart
signal OnResultScreenStart
signal OnResultScreenEnd
signal OnWinnerScreenStart
signal OnWinnerScreenEnd

func _process(delta: float) -> void:
	currentState.Update(delta)
