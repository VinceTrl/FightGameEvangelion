class_name Eva

extends Node3D

@export var AnimationPlayerName:String = "AnimationPlayer"
var animPlayer: AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animPlayer = GetAnimationPlayerWithName(self,AnimationPlayerName)
	if animPlayer: print("ANIM PLAYER FOUND")
	Manager.gameManager.RegisterEva(self)


func GetAnimationPlayerWithName(node: Node,animationPlayerName: String) -> AnimationPlayer:
	for child in node.get_children():
		if child is AnimationPlayer and child.name == animationPlayerName:
			return child
		# Recherche récursive dans les enfants
		var found = GetAnimationPlayerWithName(child,animationPlayerName)
		if found:
			return found
	return null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func StartSlap():
	animPlayer.play("Armature|Slap")
	pass
