extends RigidBody3D

@export var moveSpeed: float = 2.0
@export var canMove = true
@export var moveDirection : Vector3 = Vector3(0.0,-1.0,0.0)

const EXPLOSION = preload("res://Scenes/Gameplay/explosion.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SetRotation()

func _physics_process(delta: float) -> void:
	MoveProjectile(delta)

func MoveProjectile(delta:float):
	if (!canMove): return
	global_position += moveDirection * (moveSpeed * delta)

func SetRotation():
	global_rotation.z = lerp_angle(global_rotation.z,atan2(moveDirection.y,moveDirection.x),1)
	
func _n_body_entered(body: Node3D) -> void:
	print("COLLISION ON " + str(owner.name))
	DestroyProjectile()
	

	
func DestroyProjectile():
	
	var explo = EXPLOSION.instantiate()
	get_tree().get_root().add_child(explo)
	explo.global_position = global_position
	queue_free()
	
	
func TakeDamage(hitboxSource: Hitbox):
	if(hitboxSource == null): return
	DestroyProjectile()


func _on_body_entered(body: Node) -> void:
	print("COLLISION ON ")
	DestroyProjectile()
