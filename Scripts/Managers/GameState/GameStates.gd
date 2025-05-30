class_name GameStates
extends Node

enum GameState {TitleScreen,CharacterSelection,LoadingFight,FightIntro,Fight,FightOutro,FightResult,WinnerScreen}

var gameStateName = "Fight"
var state: GameState = GameState.TitleScreen
var manager: Manager


signal enterState
signal exitState

func EnterState():
	enterState.emit()
	
func ExitState():
	exitState.emit()

func Draw():
	pass
	
func Update(delta: float):
	pass
