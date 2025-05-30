class_name MasterUI
extends Control


@onready var fight_text: FightText = $CanvasLayer/FightText
@onready var timer_root: Control = $CanvasLayer/TimerRoot
#@onready var title_screen: TitleScreen = $CanvasLayer/TitleScreen
@onready var result_screen: ResultScreen = $CanvasLayer/ResultScreen


func _ready():
	Manager.masterUI = self
