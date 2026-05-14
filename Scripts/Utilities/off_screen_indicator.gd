extends VisibleOnScreenNotifier3D

@export var sprite:Sprite2D
@export var px_offset := 200
@export var rotateSprite:bool = true
const EPSILON = 0.0001

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_entered.connect(on_screen_entered)
	screen_exited.connect(on_screen_exited)

func on_screen_entered():
	set_process(false)
	sprite.visible = false

func on_screen_exited():
	set_process(true)
	sprite.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	ProcessIndicator()
	
func ProcessIndicator():
	var viewport_center := get_viewport().get_visible_rect().size * 0.5
	var cam_to_pos := get_viewport().get_camera_3d().to_local(global_transform.origin)
	var center_to_edge := Vector2(cam_to_pos.x, -cam_to_pos.y)
	var element := int(center_to_edge.abs().aspect() < viewport_center.aspect())
	center_to_edge *= viewport_center[element] / max(abs(center_to_edge[element]), EPSILON)
	sprite.position = viewport_center + center_to_edge - center_to_edge.normalized() * px_offset
	if(rotateSprite):
		sprite.rotation = center_to_edge.angle() + PI * 0.5 # PI to fix image initial rotation
