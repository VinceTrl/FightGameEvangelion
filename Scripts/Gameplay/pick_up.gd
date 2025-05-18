class_name Item
extends Node3D

@onready var area_3d: Area3D = $Area3D
@onready var node_shaker: NodeShaker = $VisualHolder/Visual/NodeShaker

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
		DestroyItem()
		
func DestroyItem():
	used = true
	node_shaker.NodeShake()
	await get_tree().create_timer(destroyDelay,true,false,false).timeout
	queue_free()

func _on_area_3d_body_entered(body: Node3D) -> void:
	GetItem(body)
