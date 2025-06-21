extends Node3D
class_name ForceToGround

@export var cast_distance: float = 10.0
@export var offset_above_ground: float = 0.05
@export var auto_align_on_ready: bool = true
@export var auto_align_on_update: bool = true
@export var floor_mask: int = 1 << 0  # Collision layer 1
@export var move_duration: float = 0.3  # Durée de l’animation
@export var easing: float = 1.0  # 1.0 = linéaire, <1 = élastique, >1 = plus rapide

var _tween: Tween

func _ready():
	if auto_align_on_ready:
		force_to_ground()
		
func _process(delta: float) -> void:
	if(auto_align_on_update):
		force_to_ground()

func force_to_ground():
	if owner == null:
		push_warning("Ce component n'a pas d'owner !")
		return

	var space_state = get_world_3d().direct_space_state
	var ray_params = PhysicsRayQueryParameters3D.create(
		owner.global_transform.origin,
		owner.global_transform.origin - Vector3.UP * cast_distance
	)
	ray_params.collision_mask = floor_mask
	ray_params.exclude = [owner]

	var result = space_state.intersect_ray(ray_params)

	if result:
		var ground_position: Vector3 = result.position + Vector3.UP * offset_above_ground
		owner.global_transform = Transform3D(owner.global_transform.basis, ground_position)
	else:
		push_warning("Aucune surface détectée sous l'owner.")
		
func GetGroundTargetPosition() -> Vector3:
	var space_state = get_world_3d().direct_space_state
	var ray_params = PhysicsRayQueryParameters3D.create(
		owner.global_transform.origin,
		owner.global_transform.origin - Vector3.UP * cast_distance
	)
	ray_params.collision_mask = floor_mask
	ray_params.exclude = [owner]

	var result = space_state.intersect_ray(ray_params)

	if result:
		var ground_position: Vector3 = result.position + Vector3.UP * offset_above_ground
		return ground_position
	else:
		return Vector3.ZERO

func MoveToGround(target_position: Vector3):
	if _tween:
		_tween.kill()
		
	_tween = create_tween()
	_tween.tween_property(owner, "global_transform:origin",target_position,move_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
