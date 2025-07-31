class_name FishHookTarget

extends Area3D

var hookHolder: FishHook
var isCaught = false

signal OnFishHookTargetCaught
signal OnFishHookTargetReleased

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func CatchTarget(_hook:FishHook):
	print("TARGET CATCH")
	isCaught = true
	hookHolder = _hook
	OnFishHookTargetCaught.emit()
	pass
	
func ReleaseTarget():
	print("TARGET RELEASED")
	isCaught = false
	hookHolder = null
	OnFishHookTargetReleased.emit()
	pass
