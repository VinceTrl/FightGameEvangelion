extends RedstoneReceiver

@export var openMesh:Node3D
@export var closeMesh:Node3D
@export var isOpen:bool = false

@onready var health_component: HealthComponent = $HealthComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	UpdateTrapDoor()
	
func OnTurnedOn():
	super()
	Switch()
	
func OnTurnedOff():
	super()
	Switch()

func Switch():
	if(isOpen):
		Close()
	else:
		Open()
	
func Open():
	isOpen = true
	UpdateTrapDoor()
	
func Close():
	isOpen = false
	UpdateTrapDoor()
	
func TakeDamage(hitbox:Hitbox):
	if (hitbox == null): return
	if(hitbox.type == Hitbox.DamageType.Volume):return
	
	health_component.ChangeHealth(-hitbox.damage)
	if(health_component.isDead):
		queue_free()
		return
	Switch()
	
func UpdateTrapDoor():
	if(isOpen):
		openMesh.visible = true
		openMesh.process_mode = Node.PROCESS_MODE_ALWAYS
		closeMesh.visible = false
		closeMesh.process_mode = Node.PROCESS_MODE_DISABLED
	else:
		openMesh.visible = false
		openMesh.process_mode = Node.PROCESS_MODE_DISABLED
		closeMesh.visible = true
		closeMesh.process_mode = Node.PROCESS_MODE_ALWAYS
