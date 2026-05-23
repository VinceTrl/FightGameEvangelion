class_name Item
extends Node3D

@onready var area_3d: Area3D = $Area3D
@onready var node_shaker: NodeShaker = $VisualHolder/Visual/NodeShaker
const VFX_2D_PICK_UP_ITEM = preload("res://Scenes/VFX/VFX2D/vfx_2d_pick_up_item.tscn")

enum ItemType {Ammo,Explo,Shield}
@export var type: ItemType = ItemType.Ammo
@export var destroyDelay: float = 0.5

@export_group("ammo variables")
@export var ammoCount: int = 1
@export_group("")

var used = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(area_3d == null): push_error("NO COL FOR ITEM : " + str(self.name))
	
func GetItem(_body: Node3D):
	if(used):return
	
	if(_body is PlayerCharacter):
		_body as PlayerCharacter
		_body.Ammo.AddAmmo(ammoCount)
		_body.MunLabel.Appear()
		DestroyItem()
		
		
func DestroyItem():
	used = true
	node_shaker.NodeShake()
	SpawnVFX()
	await get_tree().create_timer(destroyDelay,true,false,false).timeout
	queue_free()

func _on_area_3d_body_entered(body: Node3D) -> void:
	GetItem(body)
	
func SpawnVFX():
	var vfx = VFX_2D_PICK_UP_ITEM.instantiate()
	vfx.global_position = global_position
	get_tree().current_scene.add_child(vfx)
