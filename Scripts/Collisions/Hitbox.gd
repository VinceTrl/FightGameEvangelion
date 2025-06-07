class_name  Hitbox
extends Area3D

@export var damage = 1
@export var owner_id = 1
enum DamageType {Melee , projectile,Volume}
@export var type: DamageType = DamageType.Melee
@export var isActive = true
@export var randomID = false

	
func _init() -> void:
	collision_layer = 3
	collision_mask = 0
	
	if(randomID):
		owner_id = (randi_range(-100000,100000))
		
func _ready() -> void:
	if(randomID):
		owner_id = (randi_range(-100000,100000))
	
func ActiveHitBox():
	isActive = true
	
func InactiveHitBox():
	isActive = false
	
func DealDamage(damagedEntityID: int = 0):
	emit_signal("OnHit")
	print("HIT")
	
signal OnHit()
