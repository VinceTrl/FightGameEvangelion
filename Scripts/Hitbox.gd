class_name  Hitbox
extends Area3D

@export var damage = 1
@export var owner_id = 1
enum DamageType {Melee , projectile}
@export var type: DamageType = DamageType.Melee

	
func _init() -> void:
	collision_layer = 4
	collision_mask = 0
	
func DealDamage(damagedEntityID: int = 0):
	emit_signal("OnHit")
	print("HIT")
	
signal OnHit()
