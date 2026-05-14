extends RigidBody3D

@export var impulseForce:float = 2.0
@export var impulseDirection:Vector3 = Vector3(0.1,1,0.0)
@export var lifeTime:float = 3.0
@export var animation_player:AnimationPlayer
@export var destroyAnimation:String = "NONE"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	apply_central_impulse(impulseDirection.normalized() * impulseForce)
	LifeTime()
	body_entered.connect(_on_body_entered)
	
func LifeTime():
	await get_tree().create_timer(lifeTime).timeout
	Destroy()
	pass
	
func Destroy():
	if(animation_player):
		if(animation_player.has_animation(destroyAnimation)):
			animation_player.play(destroyAnimation)
			await animation_player.animation_finished
	queue_free()
	pass


func _on_body_entered(body: Node):
	if(body is StaticBody3D):
		constant_torque = Vector3.ZERO
		
		
	pass # Replace with function body.
