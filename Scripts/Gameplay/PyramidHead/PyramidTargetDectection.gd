class_name PyramidHeadTargetDetection

extends ShapeCast3D

@export var alwaysProcessDetection:bool = false
@export var drawDebugCast:bool = false

var targetInCast:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	DebugCast()
	if(alwaysProcessDetection):
		ProcessDetection()

func EnableDetection(enable:bool):
	enabled = enable

func ProcessDetection():
	if(is_colliding()):
		var targetDetected:bool = false
		for collision in get_collision_count():
			if(get_collider(collision).is_in_group("PyramidHeadTarget")):
				targetDetected = true
		if(!targetInCast and targetDetected):
			targetInCast = true
		elif(targetInCast and targetDetected):
			return
		else:
			targetInCast = false
	else:
		targetInCast = false
		
func DebugCast():
	if(!drawDebugCast):return
	if(is_colliding()):
		for collision in get_collision_count():
			var position := get_collision_point(collision)
			DebugDraw3D.draw_sphere(position,0.1,Color.GREEN)
			#DebugDraw3D.draw_square(position,0.2,Color.CRIMSON)
