extends Control


#@onready var lifeContainer: HBoxContainer = $CanvasLayer/LifeBar/Life
#@onready var ammoContainer: HBoxContainer = $CanvasLayer/AmmoBar/Ammo
@onready var lifeContainer: Control = $TextureBackgroundHP/ControlHP
@onready var ammoContainer: HBoxContainer = $TextureBackgroundHP/AmmoContainer


@export var playerIndex = 0
var player: PlayerCharacter
var LifePoints = []
var AmmoPoints = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	for life in lifeContainer.get_children():
		LifePoints.append(life)
		
	for ammo in ammoContainer.get_children():
		AmmoPoints.append(ammo)
	
	player = Manager.gameManager.players[playerIndex]
	
	if player== null:
		push_error("player not found in player BAR GUI: " + str(self.name))
		return
		
	player.OnPlayerTakeDamage.connect(UpdateLifeBar)
	player.OnPlayerDeath.connect(UpdateLifeBar)
	player.OnPlayerLifeChanged.connect(UpdateLifeBar)
	
	player.OnPlayerShoot.connect(UpdateAmmo)
	player.Ammo.OnAmmoAdded.connect(UpdateAmmo)
	player.Ammo.OnAmmoRemoved.connect(UpdateAmmo)
	
	UpdateLifeBar()
	UpdateAmmo()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	updateReloadBar()
	
func playerTakeDamage():
	updateLifeText()
	#animation_player.play("Damaged")
	
func playerDeath():
	#print("DEATH SIGNAL RECEIVED")
	updateLifeText()
	#animation_player.play("Death")
	
func updateReloadBar():
	#print("UPDATE Loading bar")
	#ammo_reload_bar.value = player.Ammo.GetReloadRatio()
	pass
	
func updateLifeText():
	#print("UPDATE LIFE")
	#life_text.text = "Life: 0" + str(player.currentHealthPoints)
	pass
	
func UpdateLifeBar():
	var hp = player.currentHealthPoints
	
	var count = 0
	for life in LifePoints:
		count += 1
		
		if(count > hp):
			life.visible = false
		else:
			life.visible = true
	
	
func UpdateAmmo():
	var ammoCount = player.Ammo.currentAmmo
	
	var count = 0
	for ammo in AmmoPoints:
		count += 1
		
		if(count > ammoCount):
			ammo.visible = false
		else:
			ammo.visible = true
	
func updateAmmoText():
	#print("UPDATE AMMO")
	#ammo_text.text = "Ammo: 0" + str(player.Ammo.currentAmmo)
	pass

func updateNameText():
	print("UPDATE Name")
	#name_text.text = "" + playerName
