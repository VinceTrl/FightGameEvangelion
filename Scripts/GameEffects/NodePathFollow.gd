class_name NodePathFollow

extends PathFollow3D

@export var pathFollowTime: float = 1
@export var pathFollowTransCurve: Curve
@export var pathFollowLoop:bool = false
@export var freeChildrenOnEnd = true

var path: Path3D
var isPlayingFollow = false
var isFollowing = false

signal OnStartFollowPath
signal OnEndFollowPath
signal OnResetFollowPath

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var parent = get_parent()
	if(parent is Path3D):
		path = parent
		
	#path.curve.set_point_position(0,global_position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func SetChildrenNode(newChild: Node3D,snapOnPosition:bool = true):
	newChild.reparent(self)
	if(snapOnPosition):
		newChild.global_position = global_position
	
func FollowPath():
	if(!isFollowing):return
	
	var timer = get_tree().create_timer(pathFollowTime,true,false,false)
	isPlayingFollow = true
	
	while timer.time_left > 0.0:
		var _timeProgress = pathFollowTime - timer.time_left 
		var _ratio = _timeProgress/pathFollowTime
		var _transCurveValue = pathFollowTransCurve.sample(_ratio)
		progress_ratio = _transCurveValue
		
		if !is_instance_valid(get_tree()):
			return
			
		await get_tree().process_frame

	#reset
	EndFollowPath()
	
	if(pathFollowLoop):
		FollowPath()
	
func StartFollowPath():
	print(str(owner.name) + " : START FOLLOW PATH")
	isFollowing = true
	FollowPath()
	OnStartFollowPath.emit()
	pass
	
func EndFollowPath():
	print(str(owner.name) +  " : END FOLLOW PATH")
	isPlayingFollow = false
	isFollowing = false
	OnEndFollowPath.emit()
	
	if(freeChildrenOnEnd):
		for child in get_children():
			child.reparent(get_tree().current_scene)
	
func PauseFollowPath():
	pass
	
func ResetFollowPath():
	pass
	
