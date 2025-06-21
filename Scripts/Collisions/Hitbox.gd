class_name  Hitbox
extends Area3D

@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@export var damage = 1
@export var owner_id = 1
enum DamageType {Melee,projectile,Volume,Slap}
@export var type: DamageType = DamageType.Melee
@export var isActive = true
@export var randomID = false

signal OnHit()
signal OnHitboxDetected(hitbox:Hitbox)
	
func _init() -> void:
	collision_layer = 4
	collision_mask = 4 #was at 0 before hitbox knockback
	
	print("LAYER :" + str(get_collision_layer()))
	
	if(randomID):
		owner_id = (randi_range(-100000,100000))
		
func _ready() -> void:
	connect("area_entered",self._on_area_entered) 
	
	if(randomID):
		owner_id = (randi_range(-100000,100000))
	
func ActiveHitBox():
	isActive = true
	#print("Active : " + str(isActive) + " on " + str(name))
	
func InactiveHitBox():
	isActive = false
	#print("Inactive : " + str(isActive) + " on " + str(name))
	
func DealDamage(damagedEntityID: int = 0):
	emit_signal("OnHit")
	print("HIT")
	
func _on_area_entered(hitbox : Hitbox) -> void:
	if (hitbox == null): return
	if (hitbox.owner == owner): return
	if (hitbox.owner_id == owner_id): return
	if (!hitbox.isActive):return
	#print(str(hitbox.owner.name) + " HITBOX DETECTED ON :" + str(owner.name))
	emit_signal("OnHitboxDetected",hitbox)
	
