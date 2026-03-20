class_name MasterUI
extends Control


@export_group("References")
@export var fight_text: FightText
@export var timer_root: Control
#@onready var title_screen: TitleScreen = $CanvasLayer/TitleScreen
#@onready var result_screen: ResultScreen = $CanvasLayer/ResultScreen
@export var result_screen: ResultScreen


func _ready():
	Manager.masterUI = self
