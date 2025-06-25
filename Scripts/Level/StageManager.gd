extends Node

@export var platformSpawnType:Global.PlatformSpawnType
@export var scenario: AnimationPlayer
@export var fixedCameraZoom:bool = false
@export var fixedCamZ: float = 4.0
@export var overrideCamZ:bool = false
@export var overrideMinCamZ: float = 3.0
@export var overrideMaxCamZ: float = 4.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Manager.gameManager.platform_manager.spawnScenario = platformSpawnType
	Manager.gameManager.OnFightStart.connect(StartSpawnScenario)
	call_deferred("SetCamera")
	call_deferred("OverrideCamZ")
	
func SetCamera():
	if(fixedCameraZoom):
		Manager.gameCamera.SetCameraOverrideZ(fixedCamZ)
		
func OverrideCamZ():
	if(overrideCamZ):
		Manager.gameCamera.OverrideMinMaxDist(overrideMinCamZ,overrideMaxCamZ)

func StartSpawnScenario():
	if(platformSpawnType != Global.PlatformSpawnType.Scripted): return
	
	if(scenario != null):
		var animations = scenario.get_animation_list()
		scenario.play(animations[0])
