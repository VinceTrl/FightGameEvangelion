extends Control

var player:PlayerCharacter
var playerAmmo:PlayerAmmo
@export var label:Label

func SetPlayer(newPlayer:PlayerCharacter):
	player = newPlayer
	playerAmmo = player.Ammo
	
	if(playerAmmo):
		playerAmmo.OnAmmoAdded.connect(UpdateLabel)
		playerAmmo.OnAmmoRemoved.connect(UpdateLabel)
		UpdateLabel()
	
func UpdateLabel():
	var currentAmmo:int = playerAmmo.currentAmmo
	var maxAmmo:int = playerAmmo.maxAmmo
	var text:String = str(currentAmmo) + "/" + str(maxAmmo)
	label.text = text
