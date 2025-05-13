extends Sprite3D

#sprite color variables
@export var hitColor: Color = Color.CRIMSON
@export var hitColorTime: float = 0.1
var initialColor: Color

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initialColor = modulate

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func HitColorEffect():
	var timer = get_tree().create_timer(hitColorTime,true,false,true)
	modulate = hitColor
	await timer.timeout
	modulate = initialColor
