class_name Hurtbox
extends Area3D

const VFX_2D_IMPACT = preload("res://Scenes/VFX/VFX2D/vfx_2d_impact_medium.tscn")
@onready var collision_shape: CollisionShape3D = $CollisionShape2D

@export var owner_id = 1
@export var randomID = false
@export var playVfxOnHit: bool = true

signal OnHurtboxTakeDamage(hitbox : Hitbox)
signal OnHurtboxHit

func _init() -> void:
	collision_layer = 32 #was at 0
	collision_mask = 4
	

func _ready() -> void:
	connect("area_entered",self._on_area_entered) 
	
	if(randomID):
		owner_id = (randi_range(-100000,100000))
		
	if(playVfxOnHit):
		OnHurtboxTakeDamage.connect(HitVfx)

func _on_area_entered(hitbox : Hitbox) -> void:
	if (hitbox == null): return
	if (hitbox.owner == owner): return
	if (hitbox.owner_id == owner_id): return
	if (!hitbox.isActive):return

	hitbox.emit_signal("OnHitWithHurtbox",self)
	hitbox.OnHitSuccess.emit()

	if owner.has_method("TakeDamage"):
		owner.TakeDamage(hitbox)
		
	emit_signal("OnHurtboxTakeDamage",hitbox)
	emit_signal("OnHurtboxHit")
	
	
func HitVfx(hitbox:Hitbox):
	var vfx = VFX_2D_IMPACT.instantiate()
	var total = owner.global_position + hitbox.owner.global_position
	
	if(hitbox.type == Hitbox.DamageType.Tooth):
		total = owner.global_position
		
	var targetPosition = total / 2
	vfx.global_position = targetPosition
	get_tree().current_scene.add_child(vfx)
