class_name HurtboxDetectionCast

extends ShapeCast3D

@export var alwaysProcessDetection:bool = false

var hurtboxInCast:bool = false
signal HurtboxDetected(hurtbox:Hurtbox)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(alwaysProcessDetection):
		ProcessHurtBoxDetection()

func EnableDetection(enable:bool):
	enabled = enable

func ProcessHurtBoxDetection():
	if(is_colliding()):
		var coll := get_collider(0)
		if coll is Hurtbox:
			if(!hurtboxInCast):
				HurtboxDetected.emit(coll)
				hurtboxInCast = true
		else:
			hurtboxInCast = false
	else:
		hurtboxInCast = false
