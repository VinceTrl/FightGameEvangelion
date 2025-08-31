extends Node3D

@export var destroyDelay = 0.2

var used = false
const VFX_2D_PICK_UP_ITEM = preload("res://Scenes/VFX/VFX2D/vfx_2d_pick_up_item.tscn")
@onready var animated_sprite_3d: AnimatedSprite3D = $Visual/AnimatedSprite3D
@onready var animation_player: AnimationPlayer = $Visual/DevilHand/AnimationPlayer


var player: PlayerCharacter


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func GetItem(_body: Node3D):
	if(used):return
	
	if(_body is PlayerCharacter):
		_body as PlayerCharacter
		player = _body
		DestroyItem()
		
func DestroyItem():
	used = true
	SpawnVFX()
	
	animated_sprite_3d.play("Hit")
	animation_player.play("Return")
	animated_sprite_3d.play("Hit")
	
	await get_tree().create_timer(destroyDelay,true,false,false).timeout
	
	var slapTarget
	
	if (player):
		slapTarget = Manager.gameManager.GetPlayerOpponent(player)
		
	if(slapTarget):
		Manager.gameManager.eva.StartSlap(slapTarget)
		
	
	
	
	queue_free()

func _on_area_3d_body_entered(body: Node3D) -> void:
	GetItem(body)
	
func SpawnVFX():
	var vfx = VFX_2D_PICK_UP_ITEM.instantiate()
	vfx.global_position = global_position
	get_tree().current_scene.add_child(vfx)
