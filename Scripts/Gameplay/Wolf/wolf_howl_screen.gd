extends Control

@export var animation:AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visibility_changed.connect(SpawnAnim)
	pass # Replace with function body.
	
func SpawnAnim():
	if(is_visible_in_tree()):
		animation.play("In")
		await animation.animation_finished
		visible = false
