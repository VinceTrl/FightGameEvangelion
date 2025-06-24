extends Node3D

@export var destroyDelay = 0.2
var used = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func GetItem(_body: Node3D):
	if(used):return
	
	if(_body is PlayerCharacter):
		_body as PlayerCharacter
		DestroyItem()
		
func DestroyItem():
	used = true
	Manager.postProcessEffects.PixelateEffect()
	await get_tree().create_timer(destroyDelay,true,false,false).timeout
	queue_free()

func _on_area_3d_body_entered(body: Node3D) -> void:
	GetItem(body)
