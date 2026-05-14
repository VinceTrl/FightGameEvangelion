extends PhysicObject

@export var hitbox:Hitbox
@export var activeHitVelocityThreshold:float = 2.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)
	ProcessHitbox()

func TakeDamage(hitboxSource: Hitbox):
	super(hitboxSource)
	if(hitboxSource):
		hitbox.owner_id = hitboxSource.owner_id

func ProcessHitbox():
	var vel:float = abs(linear_velocity.length())
	#DebugDraw3D.draw_text(global_position + (Vector3.BACK * 0.5),str(vel),50)
	
	if(vel > activeHitVelocityThreshold):
		hitbox.ActiveHitBox()
	else:
		hitbox.InactiveHitBox()
