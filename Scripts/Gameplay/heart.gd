extends Node3D

@onready var area_3d: Area3D = $Area3D

const AUDIO_SCENE = preload("res://Scenes/Audio/audio_scene.tscn")
const HEAL_SFX = preload("res://Assets/Sounds/SFX/MAGSpel_Anime Ability Ready 7_01.wav")
@export var destroyDelay: float = 0.05
@export var healthCount: int = 1

var used = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_3d.body_entered.connect(_on_area_3d_body_entered)
	#area_3d.area_entered.connect(_on_area_3d_body_entered)
	if(area_3d == null): push_error("NO COL FOR ITEM : " + str(self.name))
	
func GetItem(_body: Node3D):
	if(used):return
	
	if(_body is PlayerCharacter):
		_body as PlayerCharacter
		_body.AddHealth(healthCount)
		DestroyItem()
		
func DestroyItem():
	used = true
	
	#audio heal
	var audio = AUDIO_SCENE.instantiate()
	get_tree().get_root().add_child(audio)
	audio.StartAudio(HEAL_SFX)
	
	await get_tree().create_timer(destroyDelay,true,false,false).timeout
	queue_free()

func _on_area_3d_body_entered(body: Node3D) -> void:
	print("HEAL")
	GetItem(body)


func _on_area_3d_entered(area: Area3D) -> void:
	print("CHARACTER IN")
