class_name GameScene
extends Node3D

signal OnSceneReady
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	emit_signal("OnSceneReady")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
