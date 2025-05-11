class_name PlayerAmmo
extends Node

@export var maxAmmo: int = 10
@export var minAmmo: int = 0
@export var startAmmo: int = 3
@export var reloadTime: float = 8.0

var currentAmmo = startAmmo
var canReload = true
var isReloading = false

#timer 
var time = 0.0

@onready var reload_timer: Timer = $"../Timers/ReloadTimer"
@onready var sfx: AudioStreamPlayer = $"../PlayerAudio/Sfx"

const loadSound = preload("res://Assets/Sounds/SFX/MAGSpel_Anime Ability Ready 2_01.wav")

signal OnAmmoAdded
signal OnAmmoRemoved
signal OnReloadTimerEnd

func _ready() -> void:
	OnReloadTimerEnd.connect(AddAmmo)
	OnReloadTimerEnd.connect(StartReloadTimer)
	StartReloadTimer()
	
func _process(delta: float) -> void:
	ReloadTimer(delta)
	
func LoadAmmo():
	if(canReload):
		pass
	
func ResetReloadTimer():
	time = 0.0
	isReloading = false
	
func StopReloadTimer():
	if(!isReloading): return
	isReloading = false
	
func StartReloadTimer():
	if(isReloading): return
	isReloading = true
	
func ReloadTimer(_delta: float):
	if(!isReloading): return
	if(!canReload): return
	
	if time < reloadTime:
		time += _delta
	else:
		ResetReloadTimer()
		OnReloadTimerEnd.emit()
		
func AddTime(_timeToAdd: float = 1):
	time += _timeToAdd
	
func AddAmmo(_amountToAdd : int = 1):
	currentAmmo += _amountToAdd
	currentAmmo = clamp(currentAmmo,minAmmo,maxAmmo)
	sfx.stream = loadSound
	sfx.play()
	
	emit_signal("OnAmmoAdded")
	
func RemoveAmmo(_amountToRemove : int = 1):
	currentAmmo -= _amountToRemove
	currentAmmo = clamp(currentAmmo,minAmmo,maxAmmo)
	emit_signal("OnAmmoRemoved")
	
func GetReloadRatio() -> float:
	var _reloadRatio = time / reloadTime
	return _reloadRatio
