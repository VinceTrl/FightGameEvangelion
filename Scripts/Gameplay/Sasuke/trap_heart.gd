extends Node3D

@onready var area_3d: Area3D = $Area3D

@export var destroyDelay: float = 0.05

const SASUKE = preload("res://Scenes/Gameplay/sasuke.tscn")

var used = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#area_3d.body_entered.connect(_on_area_3d_body_entered)
	#area_3d.area_entered.connect(_on_area_3d_body_entered)
	if(area_3d == null): push_error("NO COL FOR ITEM : " + str(self.name))
	
func GetItem(_body: Node3D):
	if(used):return
	
	if(_body is PlayerCharacter):
		used = true
		_body as PlayerCharacter
		DestroyItem()
		
func DestroyItem():
	used = true
	
	#audio heal
	var sasuke = SASUKE.instantiate()
	get_tree().current_scene.add_child(sasuke)
	sasuke.global_position = global_position
	
	await get_tree().create_timer(destroyDelay,true,false,false).timeout
	queue_free()

func _on_area_3d_body_entered(body: Node3D) -> void:
	print("SASUKE")
	GetItem(body)
