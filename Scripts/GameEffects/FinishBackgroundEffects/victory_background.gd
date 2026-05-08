extends Node3D


@export var background_quad: MeshInstance3D
@export var victoryBackgrounds:Array[CameraBackground]
@export var deathBackgrounds:Array[CameraBackground]
@export var scrollAnimPlayer:AnimationPlayer

@export_group("DEBUG")
@export var activeDebug:bool = false
@export var forcedBackgroundIndex:int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	call_deferred("ConnectSignals")
	#background_quad.visible = false
	visible = false
	
	
func ConnectSignals():
	Manager.replayManager.ReplayFinished.connect(ShowVictoryBackground)
	Manager.gameManager.FightEnd.connect(ShowDeathBackground)

func ShowVictoryBackground():
	SetUpBackground(GetRandomBackground(victoryBackgrounds))
	visible = true
	
func ShowDeathBackground():
	SetUpBackground(GetRandomBackground(deathBackgrounds))
	visible = true
	
func SetUpBackground(background:CameraBackground):
	var mat := background_quad.get_surface_override_material(0) as StandardMaterial3D
	mat.albedo_texture = background.texture
	
	match background.scrollDirection:
		CameraBackground.ScrollDirection.NONE:
			scrollAnimPlayer.play("RESET")
		CameraBackground.ScrollDirection.RIGHT:
			scrollAnimPlayer.play("ScrollHorizontal_Right")
		CameraBackground.ScrollDirection.LEFT:
			scrollAnimPlayer.play("ScrollHorizontal_Left")
		CameraBackground.ScrollDirection.UP:
			scrollAnimPlayer.play("ScrollVertical_Up")
		CameraBackground.ScrollDirection.DOWN:
			scrollAnimPlayer.play("ScrollVertical_Down")
			
	scrollAnimPlayer.speed_scale = background.speedScale
			
func GetRandomBackground(backgrounds:Array[CameraBackground]) -> CameraBackground:
	if(activeDebug):
		return backgrounds[forcedBackgroundIndex]
	return backgrounds.pick_random()
