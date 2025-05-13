extends Control

@export var player: PlayerCharacter
@export var playerName: StringName = "Pilot:1"

@onready var life_text: Label = $Control/InfoPanel/LifeText
@onready var ammo_text: Label = $Control/InfoPanel/AmmoText
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var name_text: Label = $Control/InfoPanel/NameText
@onready var ammo_reload_bar: ProgressBar = $Control/AmmoReloadBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if player== null:
		push_error("player not found in player UI: " + str(self.name))
		return
		
	player.OnPlayerTakeDamage.connect(playerTakeDamage)
	player.OnPlayerDeath.connect(playerDeath)
	player.OnPlayerShoot.connect(updateAmmoText)
	player.Ammo.OnAmmoAdded.connect(updateAmmoText)
	player.Ammo.OnAmmoRemoved.connect(updateAmmoText)
	
	updateNameText()
	updateAmmoText()
	updateLifeText()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	updateReloadBar()
	
func playerTakeDamage():
	updateLifeText()
	animation_player.play("Damaged")
	
func playerDeath():
	#print("DEATH SIGNAL RECEIVED")
	updateLifeText()
	animation_player.play("Death")
	
func updateReloadBar():
	#print("UPDATE Loading bar")
	ammo_reload_bar.value = player.Ammo.GetReloadRatio()
	
func updateLifeText():
	#print("UPDATE LIFE")
	life_text.text = "Life: 0" + str(player.currentHealthPoints)
	
func updateAmmoText():
	#print("UPDATE AMMO")
	ammo_text.text = "Ammo: 0" + str(player.Ammo.currentAmmo)

func updateNameText():
	print("UPDATE Name")
	name_text.text = "" + playerName
