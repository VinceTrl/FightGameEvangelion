class_name PlayerGUI_HP
extends AnimatedSprite2D

#@export var textureHP: CompressedTexture2D = preload("res://Assets/Sprites/GUI/KikiGUI/GUI_LifePoint_P1.png")
@export var playerIndex = 1
var isActive = true

func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func SetHpIdle():
	print("SET IDLE IN HP GUI")
	isActive = true
	if(playerIndex == 1):
		play("P1_Idle")
	else:
		play("P2_Idle")
	await animation_finished
	#visible = true

func RemoveHp():
	if(!isActive): return
	
	isActive = false
	print("REMOVE HP GUI")
	if(playerIndex == 1):
		play("P1_Hit")	
	else:
		play("P2_Hit")
		
	await animation_finished
	#visible = false
