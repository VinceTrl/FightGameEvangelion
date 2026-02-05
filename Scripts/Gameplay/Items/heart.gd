extends Node3D

@onready var area_3d: Area3D = $Area3D
@onready var visual: Node3D = $Visual

const AUDIO_SCENE = preload("res://Scenes/Audio/audio_scene.tscn")
const HEAL_SFX = preload("res://Assets/Sounds/SFX/MAGSpel_Anime Ability Ready 7_01.wav")
@export var destroyDelay: float = 0.05
@export var healthCount: int = 1
@export var bounceScale = 1.25

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
	
func TakeDamage(hitboxSource: Hitbox):
	if(hitboxSource.type == hitboxSource.DamageType.projectile): 
		Bounce(0.25)

func Bounce(_animDuration: float = 0.6,_scaleToAdd: float = 0.25):
	
	var initScale = visual.scale
	var targetScale = bounceScale
	
	var tweenScaleIn = get_tree().create_tween()
	tweenScaleIn.set_ease(Tween.EASE_OUT)
	tweenScaleIn.set_trans(Tween.TRANS_BOUNCE)
	tweenScaleIn.set_parallel(true)
	
	
	tweenScaleIn.tween_property(visual,"scale:x",targetScale,_animDuration)
	tweenScaleIn.tween_property(visual,"scale:y",targetScale,_animDuration)
	await tweenScaleIn.tween_property(visual,"scale:z",targetScale,_animDuration).finished
	
	visual.scale = initScale
	
	#var tweenScaleOut = get_tree().create_tween()
	#tweenScaleOut.set_ease(Tween.EASE_OUT)
	#tweenScaleOut.set_trans(Tween.TRANS_BOUNCE)
	#tweenScaleOut.set_parallel(true)
	#
	#
	#tweenScaleOut.tween_property(visual,"scale:x",initScale,_animDuration)
	#tweenScaleOut.tween_property(visual,"scale:y",initScale,_animDuration)
	#tweenScaleOut.tween_property(visual,"scale:z",initScale,_animDuration).finished
	
	#visual.scale = initScale
	

func _on_area_3d_body_entered(body: Node3D) -> void:
	print("HEAL")
	GetItem(body)


func _on_area_3d_entered(area: Area3D) -> void:
	print("CHARACTER IN")
