extends Label3D

func _ready() -> void:
	self.visible = false
	
func Appear():
	self.visible = true
	await get_tree().create_timer(0.6).timeout
	self.visible = false
