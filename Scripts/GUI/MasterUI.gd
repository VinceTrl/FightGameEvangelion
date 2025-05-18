class_name MasterUI
extends Control

@onready var fight_text: FightText = $FightText
@onready var timer_root: Control = $TimerRoot
@onready var title_screen: TitleScreen = $TitleScreen


func _ready():
	Manager.masterUI = self
