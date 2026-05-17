class_name  Hitbox
extends Area3D

@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@export var damage = 1
@export var owner_id = 1
enum DamageType {Melee,projectile,Volume,Slap,Beyblade,Tooth,Explosion}
@export var type: DamageType = DamageType.Melee
@export var isActive = true
@export var randomID = false
@export var hitDirection:Vector3 = Vector3.RIGHT
@export var hitForce:float = 1.0
@export var playFxOnHit:bool = true
@export var forceFxOnHurtbox:bool = false

@export_group("DEBUG")
@export var debugShape: bool = false
@export var debugText: bool = false

signal OnHit()
signal OnHitboxDetected(hitbox:Hitbox)
signal OnHitSuccess
signal OnHitWithHurtbox(hurtbox:Hurtbox)
	
func _init() -> void:
	collision_layer = 4
	collision_mask = 4 #was at 0 before hitbox knockback
	hitDirection = hitDirection.normalized()
	
	print("LAYER :" + str(get_collision_layer()))
	
	if(randomID):
		owner_id = (randi_range(-100000,100000))
		
	#get collision shape
	
	for child in get_children(true):
		if(child is CollisionShape3D):
			collision_shape = child
	
	if(!collision_shape):
		collision_shape = Global.GetNodeOfTypeInHierarchy(self,CollisionShape3D)
		#for child in get_children():
			#if(child is CollisionShape3D):
				#collision_shape = child
		
func _ready() -> void:
	connect("area_entered",self._on_area_entered) 
	
	if(!collision_shape):
		for child in get_children(true):
			if(child is CollisionShape3D):
				collision_shape = child
				
	if(Manager.gameDebug.debugHitboxShape):
		debugShape = Manager.gameDebug.debugHitboxShape
		
	if(Manager.gameDebug.debugHitboxText):
		debugText = Manager.gameDebug.debugHitboxShape
	
	if(randomID):
		owner_id = (randi_range(-100000,100000))
		
func _process(delta: float) -> void:
	DebugHitbox()
		
func DebugHitbox():
	
	if(debugShape and collision_shape != null):
		var colShape = collision_shape.shape
		
		var color = Manager.gameDebug.debugInactiveColor
		var thickness = Manager.gameDebug.debugInactiveLineThickness
		
		if(isActive):
			color = Manager.gameDebug.debugActiveColor
			thickness = Manager.gameDebug.debugActiveLineThickness
			
			
		DebugDraw3D.scoped_config().set_thickness(thickness)
		
		if(colShape is BoxShape3D):
			colShape as BoxShape3D
			#var center: bool = collision_shape.position == Vector3.ZERO
			DebugDraw3D.draw_box(global_position + collision_shape.position * scale,quaternion,colShape.size,color,true)
		elif(colShape is SphereShape3D):
			colShape as SphereShape3D
			DebugDraw3D.draw_sphere(global_position + collision_shape.position * scale,colShape.radius,color)
		elif(colShape is CylinderShape3D):
			colShape as CylinderShape3D
			var origin = global_position + collision_shape.position
			origin.y = origin.y - (colShape.height/2)
			var end = global_position + collision_shape.position
			end.y = origin.y + (colShape.height/2)
			DebugDraw3D.draw_cylinder_ab(origin,end,colShape.radius,color)
			
	if(debugText):
		var idText = "ID = " + str(owner_id)
		var damageText = "\n Dmg = " + str(damage)
		var damageType = "\n Type = " + str(type)
		var text = idText + damageText + damageType
		DebugDraw3D.draw_text(global_position + collision_shape.position,text)
		
		
func SetHitDirection(_hitDirection:Vector3):
	hitDirection = _hitDirection.normalized()
	
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
	
