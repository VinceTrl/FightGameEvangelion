class_name Hurtbox
extends Area3D

@onready var collision_shape: CollisionShape3D = $CollisionShape2D
@export var owner_id = 1
@export var randomID = false

signal OnHurtboxTakeDamage(hitbox : Hitbox)

func _init() -> void:
	collision_layer = 0
	collision_mask = 4
	

func _ready() -> void:
	connect("area_entered",self._on_area_entered) 
	
	if(randomID):
		owner_id = (randi_range(-100000,100000))

func _on_area_entered(hitbox : Hitbox) -> void:
	if (hitbox == null): return
	if (hitbox.owner == owner): return
	if (hitbox.owner_id == owner_id): return
	if (!hitbox.isActive):return

	if owner.has_method("TakeDamage"):
		owner.TakeDamage(hitbox)
		
	emit_signal("OnHurtboxTakeDamage",hitbox)
