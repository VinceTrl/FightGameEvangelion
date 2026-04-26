extends Spell

@onready var hurt_box_detection: Area3D = $HurtBoxDetection
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var health_component: HealthComponent = $HealthComponent
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var followOffset:Vector3 = Vector3.ZERO

@export_category("Effect")
@export var freezeFrameDuration:float = 0.25
@export var cameraShake:String = "HitShake"
@export var nodeShaker:NodeShaker

var linkedHurtbox:Hurtbox


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	ProcessArmor()
	
func ProcessArmor():
	if(linkedHurtbox):
		global_position = linkedHurtbox.global_position + followOffset
	pass

func TakeDamage(hitbox:Hitbox):
	health_component.ChangeHealth(-hitbox.damage)
	
	Manager.timeManager.freezeFrame(0.001,freezeFrameDuration)
	Manager.gameCamera.camShake.AskCamShake(cameraShake)
	nodeShaker.NodeShake()
	animation_player.play("Hurt")
	
	if(health_component.isDead):
		DestroySpell()
		return
		
	await animation_player.animation_finished
	animation_player.play("Idle")
	
	
func CastSpell(duration:float = lifeTime,target:Node3D = null):
	super(duration,target)
	animation_player.play("Spawn")
	pass
		
func DestroySpell():
	super()
	animation_player.play("Death")
	await animation_player.animation_finished
	if(linkedHurtbox):
		hurtbox.isActive = false
		linkedHurtbox.isActive = true
	queue_free()


func _on_hurt_box_detection_area_entered(area: Area3D) -> void:
	if(linkedHurtbox):return
	if(area == hurtbox):return
	
	if(area is Hurtbox):
		if(!area.isActive): return
		if(area.owner is Spell):return
		
		linkedHurtbox = area
		linkedHurtbox.isActive = false
		hurtbox.isActive = true
		hurtbox.owner_id = linkedHurtbox.owner_id
		pass
